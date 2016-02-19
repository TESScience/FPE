#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <fcntl.h>
#include <signal.h>
#include <stdint.h>
#include "tess_camlink.h"
#include "tess_fits.h"
#include "tess_utils.h"
#include "tess_notes.h"
#include "camera.h"
#include "gps.h"


int do_write_fits = 1;

static void usage () {
  fprintf(stderr,"Usage:\tobssim2fits\t-n <number of output frames> default is 1\n"
	  "\t\t\t-r <run ID (string)>\n"
	  "\t\t\t-c x1 x2 y1 y2 (crop image) default is FFI\n"
	  "\t\t\t-k <keyword file>  keyword  to the fits files\n"
	  "\t\t\t-e <exposure time per input frame>\n"
	  "\t\t\t-u <n> unscramble flag: default is 1. n=0 means sky pixels only,\n"	 
	  "\t\t\t\t  n=1 means include all pixels and n=-1 means raw scrambled pixels\n"
	  "\t\t\t-s <file of column map> \n");
  exit(EXIT_FAILURE);
}


int doScramble=1;
double exposure=2.0;
int doCrop=0;
int crop[4];
unsigned frame_num=1;
char    inputFileName[128];
char    keyWordFileName[128];
char    colmapFileName[128];
char    runId[128];
/*
 * process command line arguments
 */
static void parseArgs(int argc, char **argv)
{
  int i,ii;
  //set defaults
  keyWordFileName[0] ='\0';
  strcpy(colmapFileName,"col.map");
  strcpy(inputFileName,"image.dat");
  for(i=1;i<argc;i++)
    {
      if (!strcmp(argv[i],"-n")){
	if (sscanf(argv[++i],"%u",&frame_num) !=1){
	  fprintf(stderr,"illegal number of frames %s\n", argv[i]);
	  usage();
	}
      }
      else if (!strncmp(argv[i],"-c",3)) {
	doCrop=1;
	for (ii=0; ii<4; ii++){
	  if (sscanf(argv[i+ii+1],"%u", crop+ii)  !=1){
	    fprintf(stderr,"invalid crop number %d, %s\n",ii,argv[i+ii+1]);
	    usage();
	  }
	  
	}
	if ((crop[3] <= crop[2]) || (crop[1] <= crop[0]))
	  usage();
	//	fprintf(stderr,"Cropping images to : %d %d %d %d.\n",crop[0],crop[1],crop[2],crop[3]);
	i+=4;
      }
      else if (!strncmp(argv[i],"-u",3)) {
	if (sscanf(argv[++i],"%u",&doScramble) !=1){
	  fprintf(stderr,"invalid -u  pixel selection. must be -1, 0 or 1.\n");
	  exit(EXIT_FAILURE);
	}
      }

      else if (!strcmp(argv[i],"-e")) {
	if (sscanf(argv[++i],"%lf",&exposure) != 1){
	  fprintf(stderr,"illegal exposure time %s\n", argv[i]);
	  usage();
	}
      }	       
      else if (!strcmp(argv[i],"-r")) strcpy(runId, argv[++i]);
      else if (!strcmp(argv[i],"-f")) strcpy(inputFileName, argv[++i]);
      else if (!strcmp(argv[i],"-k")) strcpy(keyWordFileName, argv[++i]);
      else if (!strcmp(argv[i],"-s")) strcpy(colmapFileName, argv[++i]);
      else if (!strcmp(argv[i],"-h")) usage();
      else if (!strcmp(argv[i],"--help")) usage();
      else 
	{
	  fprintf(stderr,"Argument %s not recognized!\n",argv[i]);
	  usage();
	}
    }
}


/*
 * main
 */

int main(int argc, char **argv)
{
  FILE *fd;
  int     ii;
  char *char_ptr;
  int imagesize;
  int s_size;
  CCD_FRAME *input_frame;
  CCD_FRAME *descrambled_frame;
  CCD_FRAME *cropped_frame;
  CCD_FRAME *integrated_frame;
  int croppedsize;
  uint16_t *colmap;
  uint16_t *short_ptr;
  int data_read=0;

  parseArgs(argc,argv);
  
  input_frame=newFrame();
  if (strlen(runId) > 0){
    strcpy(input_frame->run,runId);
  }else{
    if (doCrop)
      strcpy(input_frame->run,"CROP");
    else
      strcpy(input_frame->run,"FFI");
    
  }

  cropped_frame=newFrame();
  integrated_frame=newFrame();
  descrambled_frame=newFrame();

  read_keywords(keyWordFileName, cropped_frame, integrated_frame, descrambled_frame);

    
  char_ptr=input_frame->command=calloc(256,1);
  for (ii=0 ; ii<argc;ii++){
    strcpy(char_ptr,argv[ii]);
    char_ptr += strlen(argv[ii]);
    *char_ptr++=0x20;
  }

  /* signal handling */
  // Use sigaction instead?
  //  signal (SIGINT, (void *)&close_device);
  //  signal (SIGTERM, (void *)&close_device);
  

  /*
   * get image size and name for display, save, printfs, etc.
   */

  strcpy(input_frame->cameratype, CAMERA_TYPE);
  input_frame->x_size = CAMERA_ROWS;
  input_frame->y_size = CAMERA_COLS;
  descrambled_frame-> depth = input_frame->depth = CAMERA_DEPTH;


  //  print_CCD_FRAME(stderr,input_frame);
  /*
   * allocate memory for the image, and make sure it's aligned on a page
   * boundary
   */

  imagesize = s_size = CAMERA_ROWS*CAMERA_COLS + CAMERA_HK_VALS;
  
  colmap = (uint16_t *) calloc(input_frame->x_size,sizeof(uint16_t));
  short_ptr = (uint16_t *) calloc(imagesize,sizeof(uint16_t));

  if (doScramble == 0){
    descrambled_frame->image =(void *)calloc(4096*4096,sizeof(uint16_t));
    descrambled_frame->x_size = 4096;
    descrambled_frame->y_size = 4096;
    if (read_colmap(colmapFileName,colmap) != 0){
      fprintf(stderr,"No unscamling.\n");
      doScramble = -1;
    }
  }
  if (doScramble == 1){
    descrambled_frame->image =(void *)calloc(imagesize,2);
    descrambled_frame->x_size = input_frame->x_size/2;
    descrambled_frame->y_size = input_frame->y_size*2;
    if (read_colmap(colmapFileName,colmap) != 0 ){
      fprintf(stderr,"No unscamling.\n");
      doScramble = -1;
    }
  }  
  
  if (doScramble == -1){
    descrambled_frame->image =(void *)calloc(imagesize,2);
    descrambled_frame->x_size = input_frame->x_size;
    descrambled_frame->y_size = input_frame->y_size;
  }  

  if (doCrop){
    croppedsize=2*(crop[1]-crop[0])*(crop[3]-crop[2]);
    fprintf(stderr,"Will be cropped to %d bytes.\n",croppedsize);
    if (croppedsize <= 0){
      fprintf(stderr,"Invalid cropped image size.\n");
      exit(7);
    }
    cropped_frame->image=(unsigned short*)calloc(croppedsize,sizeof(unsigned short));
    if (cropped_frame->image == NULL){
      fprintf(stderr,"Unable to allocate %d bytes for cropped imgage.\n",croppedsize);
      exit(8);
    }
  }
  if ((fd = fopen(inputFileName,"r")) == NULL){
    perror("Failed to open file");
    exit(EXIT_FAILURE);
  }
  

  while (data_read < imagesize){
    if ((ii = fread(short_ptr + data_read,2,imagesize-data_read, fd)) == 0){
      perror("Failed to read file");
      exit(EXIT_FAILURE);
    }
    data_read += ii;
  }

  for (ii=0; ii<CAMERA_HK_VALS; ii++)
    printf("HK_VAL%02d\t\t%u\n",ii, (unsigned) short_ptr[ii + CAMERA_ROWS*CAMERA_COLS]);

  input_frame->image = (void *) short_ptr;
  input_frame->subsequence=0;
  time(&input_frame->start_time);
  input_frame->integration_time = 2;
  input_frame->numFrames = 1;
  
  unscramble(input_frame, descrambled_frame,colmap, doScramble);
  if (doCrop){
    crop_image(descrambled_frame, cropped_frame,crop);
  //	  print_CCD_FRAME(stderr,cropped_frame);
    if (do_write_fits) write_fits(cropped_frame);	  
  } else {
    if (do_write_fits) write_fits(descrambled_frame);
  }
  fprintf(stderr,"obssim2fits: done\n");
  exit(EXIT_SUCCESS);
}

