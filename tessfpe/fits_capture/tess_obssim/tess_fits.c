#include <stdio.h>
#include <strings.h>
#include <string.h>
#include <fitsio.h>
#include "tess_camlink.h"
#include "tess_fits.h"
#include "tess_utils.h"
#include "tess_housekeeping.h"

int read_fits(char *filename, CCD_FRAME *frame){
  int S=0;
  fitsfile *fptr;
  int s=0,naxis,anynul;
  long fpixel[2];
  long axes[2];
  int ii;
  int bitpix;
  int naxes=2;
  char comment[64];
  char tok[2] = "_";
  char *token;
  int16_t *ptr;
  fpixel[0] = fpixel[1] = 1;
  fprintf(stderr,"reading file %s\n",filename);
  fits_open_file(&fptr,filename,READONLY,&S);
  fits_report_error(stderr,S);
  bzero(comment,64);
  fits_get_img_dim(fptr,&naxis,&s);
  fits_report_error(stderr,s);
  fprintf(stderr,"number of axes %d\n",naxes);
  fits_get_img_size(fptr, 3, axes, &s);  
  fits_report_error(stderr,s);
  fprintf(stderr,"axes %ld %ld\n",axes[0],axes[1]);
  token = strtok(filename,tok);
  strcpy(frame->run, token);
  frame->x_size = axes[0];
  frame->y_size = axes[1];
  frame->depth = bitpix = 16;
  if (frame->depth == 16)
    frame->image = (int16_t *)calloc(axes[0]*axes[1],sizeof(int16_t));
  if (frame->image == NULL){
    fprintf(stderr, "error allocating memory for image\n");
    return 1;
  }
  ptr = (int16_t *) frame->image;
  for (ii=0; ii< axes[1]; ii++){
    fits_read_img(fptr,TSHORT,1+ii*axes[0],axes[0],NULL,ptr+ii*axes[0],&anynul,&s);
    fits_report_error(stderr,s);
  }
  fprintf(stderr, "got image %u %u %u \n",ptr[0],ptr[2], ptr[9231]);
  fflush(stderr);
  return 0;
}

  
int write_fits(CCD_FRAME *frame)
{
  /* fitsio */
  char *error_log; 
  char msg[80];
  float dd;
  fitsfile *fitsd;
  int fits_status=0;
  char out_file_name[1024];
  long naxes[2];
  int ii;
  int mgps;
  int naxis=2;
  long group=0;
  POINTING_STATS stats;
  short * short_ptr=(short *)frame->image;
  long * long_ptr=(long *)frame->image;

  if (frame->cen !=0){
    centroid_stats(frame->cen, &stats,2.0);
    fprintf(stderr,"wstats: %d %d %lf %lf %lf %lf %lf %lf %lf\n", frame->sequence, stats.numGood, stats.medX, stats.medY,stats.aveX,stats.aveY,stats.rmsX,stats.rmsY, stats.rms);
  }
  if (frame->image == NULL)
    {
      fprintf(stderr,"write_fits: No image in frame->\n");
      return(1);
    }
  error_log = (char *) malloc(FLEN_ERRMSG);
  if (frame->subsequence == 0)
    sprintf (out_file_name, "!%s_%04d.fits", frame->run,frame->sequence);
  naxes[0] = frame->x_size;  
  naxes[1] = frame->y_size;

  FITS_CHECK_ERROR(fits_create_file (&fitsd, out_file_name, &fits_status));

  if (frame->depth == 16){
    FITS_CHECK_ERROR(fits_create_img (fitsd, SHORT_IMG, naxis, naxes, 
				      &fits_status));
  }else if(frame->depth == 32){
    FITS_CHECK_ERROR(fits_create_img (fitsd, LONG_IMG, naxis, naxes, 
    		     &fits_status));
  }  else{
    fprintf(stderr,"Can't deal with image depth of %d\n",frame->depth);
    return(-1);
  }
  //  fprintf (stderr,"output file is %s at %s\n", out_file_name,asctime(gmtime(&frame->start_time)));
    
  /* write Date */
  FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, "DATE-OBS", 
				   asctime(gmtime(&frame->start_time)), 
				   "UTC start date of observation", 
				   &fits_status));
  mgps=frame->start_time-1315964784;
  FITS_CHECK_ERROR(fits_write_key (fitsd, TINT, "MGPS-OBS", 
				   &mgps, 
				   "start time in MGPS", 
				   &fits_status));
  /* Camera info */
  FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, "CAMERA", 
				   frame->cameratype, 
				   "Type of camera", 
				   &fits_status));

  /* write quality flag */
  FITS_CHECK_ERROR(fits_write_key (fitsd, TINT, "QUALITY", 
				   &frame->quality, 
				   "Data quality (0: OK, -1: first, -2: overrun)", 
				   &fits_status));
  
  /* write number of raw frames */
  FITS_CHECK_ERROR(fits_write_key (fitsd, TINT, "N_FRAMES",
				   &frame->numFrames, 
				   "Number of Raw Frames", 
				   &fits_status));

  /* write sequence number */
  FITS_CHECK_ERROR(fits_write_key (fitsd, TINT, "SEQUENCE",
				   &frame->sequence, 
				   "Sequence number of current file", 
				   &fits_status));

  /* write exposure*/
  FITS_CHECK_ERROR(fits_write_key (fitsd, TDOUBLE, "EXPOSURE",
				   &frame->integration_time,
				   "Integration time of current file",
				   &fits_status));
  /* write command*/
  if (frame->command != NULL){
    char *str = frame->command;
    char cmd[10];
    if (strlen(str)< 69){
      FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, "COMMAND",
				   frame->command,
				   0,
				   &fits_status));
    }else{
      ii=0;
      while ((strlen(str) > 69)&& (ii<9)){
	sprintf(cmd,"COMMAND%d",ii);
	FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, cmd,
					 str, 0,
					 &fits_status));
	str += 68;
	ii++;
      }
      if (strlen(str) >0 ){
	sprintf(cmd,"COMMAND%d",ii);
	FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, cmd,
					 str, 0,
					 &fits_status));
      }
    }
  }

	/* write crop*/
  if ((frame->crop[0] + frame->crop[1] + frame->crop[2] +frame->crop[3]) != 0){
    sprintf(msg,"%d %d %d %d",frame->crop[0] ,frame->crop[1] ,frame->crop[2] ,frame->crop[3]);
    FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, "CROP",
				     msg,
				     "FRAME was cropped",
				     &fits_status));
  }

  /* write Position*/
  if (frame->cen != 0){
    sprintf(msg,"%.4lf %.4lf",stats.aveX,stats.aveY);

    FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, "POINTING",
				     msg,
				     "X,Y pointing offset in pixels ",
				     &fits_status));
    /* write RMS*/
    dd=stats.rms;
    FITS_CHECK_ERROR(fits_write_key (fitsd, TFLOAT, "POS_RMS", &dd,
				     "RMS scatter of position",
				     &fits_status));
    /* write Number of good stars*/
  
    FITS_CHECK_ERROR(fits_write_key (fitsd, TINT, "NUMSTARS",
				     &stats.numGood,
				     "Number of guides stars that fit",
				     &fits_status));


  }else{
  
    ii=0;
    FITS_CHECK_ERROR(fits_write_key (fitsd, TINT, "NUMSTARS",
				     &ii,
				     "Number of guides stars that fit",
				     &fits_status));
    
  }

  for (ii = 0; ii<frame->numkeys; ii++)
    FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, frame->keyword[ii],
				     frame->keyvalue[ii], "",&fits_status));


  /* write image */
  if (frame->depth==16){
    FITS_CHECK_ERROR(fits_write_2d_sht (fitsd, group, naxes[0],naxes[0],
				      naxes[1], short_ptr, &fits_status));
  } else {
    FITS_CHECK_ERROR(fits_write_2d_lng (fitsd, group, naxes[0],naxes[0],
				      naxes[1], long_ptr, &fits_status));
  }
 
  FITS_CHECK_ERROR(fits_close_file (fitsd, &fits_status));
  return(0);
}

int write_stamp(CCD_FRAME *frame,GuideStamp *stamp)
{
  /* fitsio */
  char *error_log; 
  char msg[80];
  fitsfile *fitsd;
  int fits_status=0;
  char out_file_name[1024];
  long naxes[2];
  int naxis=2;
  long group=0;
  short * short_ptr=(short *)frame->image;
  long * long_ptr=(long *)frame->image;
  if (frame->image == NULL)
    {
      fprintf(stderr,"write_fits: No image in frame->\n");
      return(1);
    }
  error_log = (char *) malloc(FLEN_ERRMSG);
  sprintf (out_file_name, "!%s_%s_%04d_%02d.fits", frame->run,stamp->id,frame->sequence,frame->subsequence);
  fprintf(stderr, "opening file %s\n",out_file_name);
  naxes[0] = frame->x_size;  
  naxes[1] = frame->y_size;

  FITS_CHECK_ERROR(fits_create_file (&fitsd, out_file_name, &fits_status));

  if (frame->depth == 16){
    FITS_CHECK_ERROR(fits_create_img (fitsd, SHORT_IMG, naxis, naxes, 
				      &fits_status));
  }else if(frame->depth == 32){
    FITS_CHECK_ERROR(fits_create_img (fitsd, LONG_IMG, naxis, naxes, 
    		     &fits_status));
  }  else{
    fprintf(stderr,"Can't deal with image depth of %d\n",frame->depth);
    return(-1);
  }
  //  fprintf (stderr,"output file is %s at %s\n", out_file_name,asctime(gmtime(&frame->start_time)));
    
  /* write Date */
  FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, "DATE-OBS", 
				   asctime(gmtime(&frame->start_time)), 
				   "UTC start date of observation", 
				   &fits_status));
  /* Camera info */
  FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, "CAMERA", 
				   frame->cameratype, 
				   "Type of camera", 
				   &fits_status));

  /* write quality flag */
  FITS_CHECK_ERROR(fits_write_key (fitsd, TINT, "QUALITY", 
				   &frame->quality, 
				   "Data quality (0: OK, -1: first, -2: overrun)", 
				   &fits_status));
  
  /* write sequence number */
  FITS_CHECK_ERROR(fits_write_key (fitsd, TINT, "SEQUENCE",
				   &frame->sequence, 
				   "Sequence number of current file", 
				   &fits_status));

  /* write exposure*/
  FITS_CHECK_ERROR(fits_write_key (fitsd, TDOUBLE, "EXPOSURE",
				   &frame->integration_time,
				   "Integration time of current file",
				   &fits_status));
  
  /* write crop*/
  if ((frame->crop[0] + frame->crop[1] + frame->crop[2] +frame->crop[3]) != 0){
    sprintf(msg,"%d %d %d %d",frame->crop[0] ,frame->crop[1] ,frame->crop[2] ,frame->crop[3]);
    FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, "CROP",
				     msg,
				     "FRAME was cropped",
				     &fits_status));
  }
  /* write command*/
  if (frame->command != NULL)
    FITS_CHECK_ERROR(fits_write_key (fitsd, TSTRING, "COMMAND",
				   frame->command,
				   "",
				   &fits_status));


  /* write image */
  if (frame->depth==16){
    FITS_CHECK_ERROR(fits_write_2d_sht (fitsd, group, naxes[0],naxes[0],
				      naxes[1], short_ptr, &fits_status));
  } else {
    FITS_CHECK_ERROR(fits_write_2d_lng (fitsd, group, naxes[0],naxes[0],
				      naxes[1], long_ptr, &fits_status));
  }
 
  FITS_CHECK_ERROR(fits_close_file (fitsd, &fits_status));
  return(0);
}
