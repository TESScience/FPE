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
#include "tess_utils.h"
#include "gps.h"
#include "obssim_udp.h"
#include "camera.h"
#include "tess_housekeeping.h"

static void usage () {
  fprintf(stderr,"Usage:\ttess_camlink\t-n <number of output frames> default is 1\n"
	  "\t\t\t-p <UDP port> \n"
	  "\t\t\t-a <IP address> default is 7777\n");
  exit(EXIT_FAILURE);
}

int UDPport=7777;
char IPaddr[20]="192.168.100.2";

unsigned frame_num=1;
/*
 * process command line arguments
 */
static void parseArgs(int argc, char **argv)
{
  int i;
  //set defaults
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
  int     i,ii;
  OBSSIM_READER reader;

  int started __attribute__((unused));
  int imagesize;
  double tt0=0,tt1,tt2;
  int rd;
  parseArgs(argc,argv);
  

  /*
   * get image size and name for display, save, printfs, etc.
   */

  imagesize = CAMERA_ROWS*CAMERA_COLS;
  
  reader_init(&reader,IPaddr,UDPport,imagesize);

  tt0=gps_now();
  started = 1;
  for (i = 0; i < frame_num; i++)
    {
      tt2=gps_now();
      if ((rd = reader_readimage(&reader)) != imagesize){
	fprintf(stderr,"readimage error: only read %d pixels", rd);
	exit(EXIT_FAILURE);
      }
      tt1=gps_now();
      fprintf(stderr,"image %d %lf %lf %lf %lf %lf\n",i,tt0,tt1,tt2,tt1-tt0, tt1-tt2);
      
      for (ii=2; ii< NUM_CAMERA_HK_VALS; ii++){
	fprintf(stderr, "HK Group %d, index %d, raw 0x%04x, %d\n", 
		reader.housebuf[0], ii-2, reader.housebuf[ii], 
		twosC2int(reader.housebuf[ii]) );
      }
     }
  reader_close(&reader);
   exit(EXIT_SUCCESS);
}

