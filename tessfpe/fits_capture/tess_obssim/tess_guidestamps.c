/*
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "tess_utils.h"
#include "tess_fits.h"
#include "gps.h"
#include "tess_guidestamps.h"

extern int nthi(int *,int,int);

float centroidGuideStamps(CCD_FRAME *frame, GuideStampList *stamps,FILE *GuideStampHkFile)
{
  int ii;
  int ier;
  int ssize[4];
  double good_ave_x=0, good_ave_y=0;
  CCD_FRAME *stamp;
  POINTING_STATS ss;
  STAR_CENTER *cc = 0;
  if (stamps == 0)
    return 0.;
  free_centroids(frame->cen);
  frame->cen=0;
  stamp = newFrame();
  if (stamps == NULL) return(0.0);
  for (ii = 0 ; ii < stamps->number ; ii++){
    ssize[0] = (int)(stamps->stamps[ii].x + 1.- stamps->xsize/2.);
    ssize[1] = ssize[0] + stamps->xsize;
    ssize[2] = (int)(stamps->stamps[ii].y + 1. - stamps->ysize/2.);
    ssize[3] = ssize[2] + stamps->ysize;
    if (crop_image(frame,stamp,ssize) == 0){
      if (stamps->stamps[ii].fits == 1){
	write_stamp(stamp,&stamps->stamps[ii]);
      }
      if ((ier = centroid(stamp,&stamps->stamps[ii],2)) == 0){
	//        printf("FIT %d started %.2f %.2f...",ii,
	//	  stamps->stamps[ii].fitx,stamps->stamps[ii].fity);
       	stamps->stamps[ii].fitx += ssize[0];
	stamps->stamps[ii].fity += ssize[2];
	stamps->stamps[ii].fitx -= stamps->stamps[ii].x;
	stamps->stamps[ii].fity -= stamps->stamps[ii].y;
	stamps->stamps[ii].fitx *= -1.;
	stamps->stamps[ii].fity *= -1.;
	//	printf("ended %.2f %.2f\n",
	//	       stamps->stamps[ii].fitx,stamps->stamps[ii].fity);
	if (GuideStampHkFile != NULL)
	  fprintf(GuideStampHkFile,"%s: %lf %lf %.0lf %.2lf %.1lf\n",
	    stamps->stamps[ii].id, 
	    stamps->stamps[ii].fitx,
	    stamps->stamps[ii].fity,
	    stamps->stamps[ii].flux,
	    stamps->stamps[ii].background,
	    gps_now());
	
	cc = add_centroid(cc,stamps->stamps[ii].fitx,stamps->stamps[ii].fity);
      } else
	fprintf(stderr,"Could not centroid %s, error %d\n",
	  stamps->stamps[ii].id,ier);
    } else fprintf(stderr,"Could not crop %s\n",stamps->stamps[ii].id);
  }
  centroid_stats(cc,&ss,0.3);
  if (GuideStampHkFile != NULL)
    fprintf(GuideStampHkFile,"Average: %lf %lf %.2lf %d %lF %lf\n",ss.aveX,ss.aveY,gps_now(),ss.numGood,ss.medX,ss.medY);

  printf("Average: %lf %lf %.2lf %d %lF %lf\n",ss.aveX-ss_Xoffset,ss.aveY-ss_Yoffset,gps_now(),ss.numGood,ss.medX,ss.medY);
  fflush(stdout);
  fflush(GuideStampHkFile);
  add_centroids(frame,cc);
  freeFrame(stamp);
  return (sqrt( good_ave_x *  good_ave_x +  good_ave_y *  good_ave_y));
}
	     
GuideStampList* newGuideStampList(char *filename)
{
  FILE *fd;
  int num,x,y;
  int ii,jj;
  GuideStamp *gs;
  GuideStampList *gsl;
  if (filename == NULL)
    return 0;
  if (filename[0] == 0)
    return 0;
  if ((fd = fopen(filename, "r")) == NULL){
    fprintf(stderr, "Unable to open guide stamp file %s\n", filename);
    return 0;
  }
  if (fscanf(fd,"Number of Stars %d\n",&num) !=1) {
    fprintf(stderr, "Unable to read guide stamp file %s\n", filename);
    return 0;
  }
  if ((ii=fscanf(fd,"Size %d %d\n",&x, &y)) !=2) {
    fprintf(stderr, "Unable to read size from guide stamp file %s, %d\n", filename, ii);
    return 0;
  }
  if (num <= 0){
    fprintf(stderr, "no guide stars in file %s, %d\n", filename,num);
    return 0;
  }
  if ((gs =  (GuideStamp *) calloc(num, sizeof(GuideStamp))) == NULL){
    fprintf(stderr, "Unable to allocate memory for %d guide stamp positions\n",num);
    return 0;
  }
  if ((gsl =  (GuideStampList *) calloc(1, sizeof(GuideStampList))) == NULL){
    fprintf(stderr, "Unable to allocate memory for guide stamp list.\n");
    return 0;
  }
  gsl->number = num;
  gsl->xsize = x;
  gsl->ysize = y;
  for (ii=0; ii< num; ii++){
    if ((jj=fscanf(fd,"%s %lf %lf %d %d %d\n",gs[ii].id,&gs[ii].x,&gs[ii].y,&gs[ii].min,&gs[ii].max,&gs[ii].fits)) != 6){
      fprintf(stderr, "Unable to read guide stamp %d from file %s,%d,%s\n",ii, filename,jj,gs[ii].id);
      return 0;
    }
  }
  gsl->stamps = gs;

  fclose(fd);
  return gsl;
}

/*
  This function calculates the centroid of a star in the subarray.
  It returns 0 if it succeeds. -1 if the star saturated the detector,
  and -2 if the star is too close to the edge.

  The fit results a put in the fit_x and fit_y elements of the star_field struct*/

int centroid(CCD_FRAME *field , GuideStamp *stamp, int rad){
  int ii, jj;
  int iimax, jjmax, max;
  int flux;
  short *short_ptr=field->image;
  int *int_ptr;
  double xd,yd;
  int xb,xt,yb,yt,npix,med,xdim __attribute__((unused)),ydim __attribute__((unused)),p;
  double bg;
  max = 0;

  xdim = field->x_size;
  ydim = field->y_size;
  npix = field->x_size*field->y_size;
  int_ptr = (int *)malloc(npix*sizeof(int));

  //  First find the Brightest pixel in the stamp
  for (ii=0; ii<field->x_size; ii++){
    for (jj=0; jj<field->y_size; jj++){
      p = ii + field->x_size*jj;
      int_ptr[p] = (int)short_ptr[p];
      if (short_ptr[p] > max){
	max = short_ptr[p];
	iimax = ii;
	jjmax = jj;
      }
    }
  }
  //  fprintf(stderr,"max pixel in %s is %d %d %d\n",stamp->id,iimax, jjmax,max);
  //
  // Algorithm call for preliminary check of pixel brightess.
  // Not quite sure how to do this yet. Leave as TBD for now.
  //

  //
  //Check if the brightest pixel is close enougth to the center of the box.
  //
  
  if ((abs((int)(iimax - (field->x_size -1)/2) > 2))
      || (abs((int)(jjmax - (field->y_size -1)/2) > 2))){
  
    fprintf(stderr, "Not using Photometric centroiding for star %s.\n",stamp->id);
    stamp->flux = stamp->min;  // use the minimum since we don't calculate it.
    stamp->fitx = iimax-1;
    stamp->fity = jjmax-1;
    return(0);
  }

  //
  // The algorithm calls for a table of pixels to use for centroid fitting
  // We will cheat for now and hardwire a 5x5 box
  //
 
  xb = (field->x_size -1)/2 - 2;
  xt = (field->x_size -1)/2 + 2;
  yb = (field->y_size -1)/2 - 2;
  yt = (field->y_size -1)/2 + 2;

  //
  // Find the field background (and slope?)
  // There are lots of better ways to do this.
  // This is quick and dirty. Using the next ring of pixels
  // 
  bg = 0;
  for (ii = xb -1 ; ii < xt + 1; ii++){
    bg += short_ptr[ii+field->x_size*(yb+3)];    
    bg += short_ptr[ii+field->x_size*(yb-3)];    
  }
  for (ii = yb ; ii < yt ; ii++){
    bg += short_ptr[xb-3+field->x_size*(ii)];    
    bg += short_ptr[xb+3+field->x_size*(ii)];    
  }
  bg /= 24;

  med = nthi(&int_ptr[0],npix,npix/2);
  //  printf("BG %d %d %.3lf %d\n",ii,jj,bg,med);
  free(int_ptr);

//  Assert that the median of the subarray is a better measure of bg

  bg = med;

  //
  // Find the Flux and centroid position.
  //
  
  flux = 0;
  xd=yd=0.0;
  for (ii=xb; ii<=xt; ii++){
    for (jj=yb; jj<= yt; jj++){
      yd += jj*(short_ptr[ii + field->x_size*jj]-bg);
      xd += ii*(short_ptr[ii + field->x_size*jj]-bg);
      flux += short_ptr[ii + field->x_size*jj]-bg;
    }
  }
  //  fprintf(stderr,"flux for star %s %d %.2lf\n",stamp->id, flux, log(flux));
  if (flux < stamp->min) {
    fprintf(stderr,"flux for %s is %d which is below the min of %d\n", stamp->id, flux, stamp->min);
    return(-3);
  }
  if (flux > stamp->max){
    fprintf(stderr,"flux for %s is %d which is above the max of %d\n", stamp->id, flux, stamp->max);
    return(-3);
  }
  stamp->background=bg;
  stamp->flux= flux;
  stamp->fitx = xd/flux;
  stamp->fity = yd/flux;
  return (0);
}
