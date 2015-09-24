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

#include "tess_camlink.h"
#include "tess_fits.h"
#include "tess_utils.h"
#include "tess_notes.h"
#include "tess_guidestamps.h"
#include "gps.h"
#include "obssim_udp.h"
#include "camera.h"
#include "tess_housekeeping.h"

static void usage () {
  fprintf(stderr,"Usage:\ttess_obssim\t-n <number of output frames> default is 1\n"
	  "\t\t\t-i <number to integrate> default is 1\n"
	  "\t\t\t-r <run ID (string)>\n"
	  "\t\t\t-c x1 x2 y1 y2 (crop image) default is FFI\n"
	  "\t\t\t-k <keyword file>  keyword  to the fits files\n"
	  "\t\t\t-h <Centroids file>  File to write the centroids to\n"
	  "\tThe following options should usual be left at default values:\n"
	  "\t\t\t-e <exposure time per input frame>\n"
	  "\t\t\t-u <n> unscramble flag: default is 1. n=0 means sky pixels only,\n"	 
	  "\t\t\t\t  n=1 means include all pixels and n=-1 means raw scrambled pixels\n"
	  "\t\t\t-m <Maximum Position Error>\n"
	  "\t\t\t-g <file of guide stamps>\n"
	  "\t\t\t-s <file of column map> \n"
	  "\t\t\t-p <UDP port> \n"
	  "\t\t\t-a <IP address> default is 7777\n");
  exit(EXIT_FAILURE);
}

GuideStampList *GuideStamps;
int do_write_fits = 1;
int UDPport=7777;
char IPaddr[20]="192.168.100.2";
int Integrate=1;
int doScramble=1;
double exposure=0.0;
int doCrop=0;
int crop[4];
unsigned frame_num=1;
char    guideStampFile[128];
char    keyWordFileName[128];
char    guideStampHKFileName[128];
char    colmapFileName[128];
char    runId[128];
double MaxPosErr=10.;
/*
 * process command line arguments
 */
static void parseArgs(int argc, char **argv)
{
  int i,ii;
  //set defaults
  guideStampFile[0] ='\0';
  keyWordFileName[0] ='\0';
  guideStampHKFileName[0] = '\0';
  strcpy(colmapFileName,"col.map");
  for(i=1;i<argc;i++)
    {
      if (!strcmp(argv[i],"-p")){
	if (sscanf(argv[++i],"%d",&UDPport) !=1){
	  fprintf(stderr,"illegal port number %s\n", argv[i]);
	  usage();
	}
      }
      else if (!strcmp(argv[i],"-n")){
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
      else if (!strncmp(argv[i],"-i",3)) {
	if (sscanf(argv[++i],"%u",&Integrate) !=1){
	  fprintf(stderr,"invalid Integration number.\n");
	  exit(EXIT_FAILURE);
	}
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
      else if (!strcmp(argv[i],"-m")) {
	if (sscanf(argv[++i],"%lf",&MaxPosErr) != 1){
	  fprintf(stderr,"illegal Maximum Position Error: %s\n", argv[i]);
	  usage();
	}
      }	       
      else if (!strcmp(argv[i],"-r")) strcpy(runId, argv[++i]);
      else if (!strcmp(argv[i],"-g")) strcpy(guideStampFile, argv[++i]);
      else if (!strcmp(argv[i],"-k")) strcpy(keyWordFileName, argv[++i]);
      else if (!strcmp(argv[i],"-h")) strcpy(guideStampHKFileName, argv[++i]);
      else if (!strcmp(argv[i],"-s")) strcpy(colmapFileName, argv[++i]);
      else if (!strcmp(argv[i],"-a")) strcpy(IPaddr, argv[++i]);

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
  int     i,j,ii;
  OBSSIM_READER reader;
  double mexp;
  char *char_ptr;
  int started __attribute__((unused));
  int imagesize;
  CCD_FRAME *input_frame;
  CCD_FRAME *descrambled_frame;
  CCD_FRAME *cropped_frame;
  CCD_FRAME *integrated_frame;
  int croppedsize;
  uint16_t *colmap;
  double tt0=0,tt1,tt2;
  double posErr;
  int rd;
  int note;
  FILE *GuideStampHKFile;

  parseArgs(argc,argv);
  

  ss_Xoffset = ss_Yoffset = 0;

  input_frame=newFrame();
  if (strlen(runId) > 0){
    strcpy(input_frame->run,runId);
  }else{
    if (doCrop)
      strcpy(input_frame->run,"CROP");
    else
      strcpy(input_frame->run,"FFI");
    
  }
  if (guideStampHKFileName[0] == 0)
    sprintf(guideStampHKFileName,"Centroids.%s",input_frame->run);

  cropped_frame=newFrame();
  integrated_frame=newFrame();
  descrambled_frame=newFrame();
  if (guideStampFile[0] != 0){
    if ((GuideStampHKFile = fopen(guideStampHKFileName,"w+")) == NULL){
      fprintf(stderr,"Unable to open Centroid File %s\n", guideStampHKFileName);
      exit(2);
    }
  }
  read_keywords(keyWordFileName, cropped_frame, integrated_frame, descrambled_frame);

    
  char_ptr=input_frame->command=calloc(256,1);
  for (ii=0 ; ii<argc;ii++){
    strcpy(char_ptr,argv[ii]);
    char_ptr += strlen(argv[ii]);
    *char_ptr++=0x20;
  }

  GuideStamps = newGuideStampList(guideStampFile);

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
  print_CCD_FRAME(stderr,input_frame);

  imagesize = CAMERA_ROWS*CAMERA_COLS;
  
  colmap = (uint16_t *) calloc(input_frame->x_size,sizeof(uint16_t));

  if (doScramble == 0){
    descrambled_frame->image =(void *)calloc(4096*4096,sizeof(int16_t));
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
      fprintf(stderr,"No unscrambling.\n");
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
    cropped_frame->image=(short*)calloc(croppedsize,sizeof(short));
    if (cropped_frame->image == NULL){
      fprintf(stderr,"Unable to allocate %d bytes for cropped imgage.\n",croppedsize);
      exit(8);
    }
  }

  reader_init(&reader,IPaddr,UDPport,imagesize);

  tt0=gps_now();
  started = 1;
  input_frame->sequence=0;
  for (i = 0; i < frame_num; i++)
    {
      /*
       *  Check for notes
       */
      note = check_for_note();
      if (note == DIE){
	reader_close(&reader);
	exit(0);
      }
      if (note){
	fprintf(stderr,"note 0x%0x\n",note);
	if (note & CHANGE_WRITE_FITS){
	  fprintf(stderr,"changing do_write_fits to %d\n",(note & WRITE_FITS) >> 8);
	  do_write_fits = (note & WRITE_FITS) >> 8;
	}
	if (note & RENAME_ROOT )   strcpy(input_frame->run,note_newroot);
	if (note & RESET_COUNTER) input_frame->sequence=0;

	if (note & READ_KEYWORDS) 
	  read_keywords(keyWordFileName, cropped_frame, integrated_frame, descrambled_frame);
      }
      for (j = 0 ; j < Integrate ; j++){
	input_frame->subsequence=j;	  
	tt2=gps_now();
	fflush(stderr);
	time(&input_frame->start_time);
	if ((rd = reader_readimage(&reader)) != imagesize){
	  fprintf(stderr,"readimage error: only read %d pixels", rd);
	  exit(EXIT_FAILURE);
	}

	tt1=gps_now();
	fprintf(stderr,"image %d frame %d %lf %lf %lf %lf %lf\n",j,i,tt0,tt1,tt2,tt1-tt0, tt2-tt1);
	mexp=tt1-tt0;
	mexp -= FRAME_TRANSFER_TIME;
	if (exposure !=0)
	  if ((mexp / exposure) > 1.1){
	    fprintf(stderr, "Camlink out of sync %lf\n",mexp);
	    reader_close(&reader);
	    exit(EXIT_FAILURE);
	  }
	tt0=tt1;
	input_frame->integration_time = mexp;
	input_frame->numFrames = 1;
	    
	/*
	fprintf(stderr,"input:\n");
	print_CCD_FRAME(stderr,input_frame);

	fprintf(stderr,"descrambled:\n");
	print_CCD_FRAME(stderr,descrambled_frame);

	fprintf(stderr,"cropped:\n");
	print_CCD_FRAME(stderr,cropped_frame);
	fprintf(stderr,"about to unscramble\n");
	*/

	input_frame->image = reader.imagebuf;
	input_frame->hkvals = reader.housebuf;
	for (ii=2; ii< NUM_CAMERA_HK_VALS; ii++){
	  fprintf(stderr, "HK Group %d, index %d, raw 0x%04x, %d\n", 
		  input_frame->hkvals[0], ii-2, input_frame->hkvals[ii], 
		  twosC2int(input_frame->hkvals[ii]) );
	}
	unscramble(input_frame, descrambled_frame,colmap, doScramble);
	posErr = centroidGuideStamps(descrambled_frame,GuideStamps, GuideStampHKFile);
	if (doCrop)
	  crop_image(descrambled_frame, cropped_frame,crop);
	if (Integrate > 1) {
	  if (posErr < MaxPosErr){
	    if (doCrop){
	      add_image(cropped_frame, integrated_frame);
	      free(cropped_frame->image);
	      cropped_frame->image=0;
	    }else
	      add_image(descrambled_frame,integrated_frame);
	  } else 
	    fprintf(stderr,"Frame %s_%d raw %d is ignored. %lf\n",integrated_frame->run, integrated_frame->sequence, j, posErr);
	}
      }
      if (Integrate == 1) {
	if (doCrop) {
	  //	  print_CCD_FRAME(stderr,cropped_frame);
	  if (do_write_fits) write_fits(cropped_frame);	  
	  free(cropped_frame->image);
	  cropped_frame->image=0;
	} else {
	  if (do_write_fits) write_fits(descrambled_frame);
	}
      } else {
	//	fprintf(stderr,"Writing Integrated Frame");
	//	print_CCD_FRAME(stderr,integrated_frame);
	if (do_write_fits) write_fits(integrated_frame);
	free(integrated_frame->image);
	integrated_frame->image=0;
      }
      input_frame->sequence++;
    }
  reader_close(&reader);
  freeFrame(cropped_frame);
  freeFrame(integrated_frame);
  freeFrame(descrambled_frame);
  //  fprintf(stderr,"tess_camlink: done\n");
  exit(EXIT_SUCCESS);
}

