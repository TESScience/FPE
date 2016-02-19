#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <string.h>
#include "tess_camlink.h"
#include "tess_utils.h"
//=================================================================
// newFrame creates a new CCD_FRAME
//

CCD_FRAME *newFrame()
{
  CCD_FRAME *frame = (CCD_FRAME *) calloc(1,sizeof(CCD_FRAME));
  frame->run=(char *)calloc(128,1);
  frame->cameratype=(char *)calloc(128,1);
  frame->command=(char *)calloc(128,1);
  frame->cen=0;
  frame->image=0;
  return frame;
}

int cmp(const void *x, const void *y)
{
  double xx = *(double*)x, yy = *(double*)y;
  if (xx < yy) return -1;
  if (xx > yy) return  1;
  return 0;
}


STAR_CENTER *add_centroid(STAR_CENTER *cen, double x,double y)
{
  STAR_CENTER *c, *cn;
  c = (STAR_CENTER *)calloc(sizeof(STAR_CENTER),1);
  c->x = x;
  c->y = y;
  c->next = NULL;
  if (cen ==NULL)
    return(c);
  else{
    cn = cen;
    while (cn->next != NULL)
      cn=cn->next;
    cn->next = c;
  }
  return(cen);
}

void add_centroids(CCD_FRAME* frame, STAR_CENTER *c)
{
  STAR_CENTER *cn,*cp;
  if (c == NULL)
    return;
  if (frame->cen == NULL){
    frame->cen = add_centroid(0,c->x,c->y);
    cp = c->next;
  }else
    cp = c;
  while (cp != NULL){
    cn=cp->next;
    add_centroid(frame->cen,cp->x,cp->y);
    cp = cn;
  }  
}

int num_centroids(STAR_CENTER *cen)
{
  STAR_CENTER *c, *cn;
  int ii=0;
  c = cen;
  while (c != 0){
    cn = c->next;
    ii++;
    c = cn;
  }
  return ii;
}

void print_centroids(STAR_CENTER *cen, FILE *s)
{
  STAR_CENTER *c, *cn;
  c = cen;
  while (c != 0){

    cn = c->next;
    fprintf(s,"%.4lf %.4lf\n",c->x, c->y);
    c = cn;
  }
  fflush(s);
}

/*
void copy_centroids(CCD_FRAME *src,CCD_FRAME *dst)
{
  STAR_CENTER *c,*cn;
  free_centroids(dst-cen);
  dst->cen=0;
  c = src->cen;
  if (c == NULL)
    dst->cen=0;
  else{
    while (c != 0){
      cn = c->next;
      add_centroid(dst->cen,c->x, c->y);
      c = cn;
    }
  }
}
*/
POINTING_STATS *centroid_stats(STAR_CENTER *cen, POINTING_STATS *stats,double max)
{
  STAR_CENTER *c, *cn;
  double *x, *y;
  int numCen;
  int ii =0;
  stats->aveX=0;
  stats->aveY=0;
  stats->numGood=0;
  stats->rmsX=0;
  stats->rmsY=0;
  stats->rms=0;
  c = cen;
  numCen=num_centroids(cen);
  x = (double *) calloc(numCen,sizeof(double));
  y = (double *) calloc(numCen,sizeof(double));
  while (c != 0){
    cn = c->next;
    x[ii] = c->x;
    y[ii] = c->y;
    c = cn;
    ii++;
  }

  qsort(x,numCen, sizeof(double),cmp);
  qsort(y,numCen, sizeof(double),cmp);

  stats->medX = x[numCen/2];
  stats->medY = y[numCen/2];
  //  fprintf(stderr,"stats: %lf %lf %lf\n", stats->medX, stats->medY,max);
  
  c = cen;
  ii=0;
  while (c != 0){
    cn = c->next;
    if (sqrt((c->x -stats->medX)*(c->x -stats->medX) + (c->y - stats->medY)*(c->y -stats->medY)) < max){
      stats->aveX += c->x;
      stats->aveY += c->y;
      stats->numGood++;
    }else{
      fprintf(stderr,"cen %d is an outlier %lf %lf\n",ii,c->x, c->y);
    }
    c = cn;
    ii++;
  }

  stats->aveX /= stats->numGood;
  stats->aveY /= stats->numGood;

  c = cen;
  while (c != 0){
    cn = c->next;
    if (sqrt((c->x -stats->medX)*(c->x -stats->medX) + (c->y - stats->medY)*(c->y -stats->medY)) < 0.1){
      stats->rmsX += (c->x - stats->aveX)*(c->x - stats->aveX);
      stats->rmsY += (c->y - stats->aveY)*(c->y - stats->aveY);
      stats->rms += (c->x - stats->aveX)*(c->x - stats->aveX)+(c->y - stats->aveY)*(c->y - stats->aveY);;
    }
    c = cn;
  }
  stats->rmsX /= stats->numGood;
  stats->rmsY /= stats->numGood;
  stats->rms /= stats->numGood;
  stats->rmsX = sqrt(stats->rmsX);
  stats->rmsY = sqrt(stats->rmsY);
  stats->rms = sqrt(stats->rms);
  free(x);
  free(y);
  return stats;
}

void free_centroids(STAR_CENTER *c)
{
  STAR_CENTER  *cn;
  while (c != 0){
    cn= c->next;
    free(c);
    c = cn;
  }
}

void freeFrame(CCD_FRAME* frame)
{
  if (frame== 0) return;
  free(frame->run);
  free(frame->cameratype);
  if (frame->image != 0)
    free(frame->image);
  free_centroids(frame->cen);
  free(frame);
}
//
//==============================================
// add_image adds an image to a 32-bit image
//===============================
int add_image(CCD_FRAME *in, CCD_FRAME *out)
{
  int x, y;
  long *in_long=(long *)in->image;
  short *in_short=(short*)in->image;
  long *out_long=(long *)out->image;
  if (in == out){
    fprintf(stderr,"add_image error. Don't add an image to itself\n");
    return(1);
  }

  if (out->image == NULL){
    if (long_image(in, out) !=0){
      fprintf(stderr,"add_image: failed to create output frame.");
      return(1);
    }
    return(0);
  }
  if (out->x_size == 0){
    out->x_size = in->x_size;
    out->y_size = in->x_size;
  }
  if (out->x_size != in->x_size){
    fprintf(stderr,"add_image error: X sizes don't match %ld vs. %ld.\n",in->x_size,out->x_size);
    return(-1);
  }
  if (out->y_size != in->y_size){
    fprintf(stderr,"add_image error: Y sizes don't match %ld vs. %ld.\n",in->y_size,out->y_size);
    return(-1);
  }
  if (out->depth == 16){
    fprintf(stderr,"Can only add to a 32-bit image");
    return(-1);
  }
  if (in->quality != 0)
    out->quality=in->quality;
  out->integration_time+=in->integration_time;
  out->stop_time=in->stop_time;
  out->hkvals=in->hkvals;
  out->numFrames++;
  //  fprintf(stderr,"out: depth=%d, x=%ld, y=%ld\n", out->depth, out->x_size, out->y_size);
  for (x=0;x< out->x_size; x++)
    for (y=0;y< out->y_size; y++)
      if (in->depth==16)
	out_long[x+ out->x_size*y]+=in_short[x+in->x_size*y];
      else
	out_long[x+ out->x_size*y]+=in_long[x+in->x_size*y];
  add_centroids(out, in->cen);
  return(0);
}

//===================================================================
// Converts a 16-bit image to a 32-bit image
//===================================================================
int long_image(CCD_FRAME *in, CCD_FRAME *out)
{
  long *out_long;
  short *in_short=(short *)in->image;
  int x, y;
  if (in->depth == 32){
    fprintf(stderr,"long_image error: image is already 32 bits.\n");
    return(-1);
  }
  copyFrame(out, in);
  out->depth=32;

  out_long=(long *)calloc(out->x_size*out->y_size,sizeof(long));
  out->image=(void *)out_long;
  for (x=0;x< out->x_size; x++)
    for (y=0;y< out->y_size; y++)
      out_long[x+ in->x_size*y]=in_short[x+in->x_size*y];
  return(0);
}
  
int crop_image(CCD_FRAME *in, CCD_FRAME *out, int crop[4])
{
  int xx, yy;
  int x, y;
  long *in_long=(long *)in->image;
  long *out_long;
  short *in_short=(short *)in->image;
  short *out_short;

  copyFrame(out,in);
  out->x_size=crop[1]-crop[0]+1;
  out->y_size=crop[3]-crop[2]+1;
  for (xx=0;xx<4; xx++)
    out->crop[xx]=crop[xx];
  if (in->depth==16)
    out->image = (void *)calloc(out->x_size*out->y_size, sizeof(short));
  else
    out->image= (void *)calloc(out->x_size*out->y_size, sizeof(long));
  out_short=(short *)out->image;
  out_long=(long *)out->image;
  //  fprintf(stderr,"out: depth=%d, x=%ld, y=%ld\n", out->depth, out->x_size, out->y_size);
  for (x=0,xx=crop[0];x< out->x_size; x++,xx++)
    for (y=0,yy=crop[2];y< out->y_size; y++,yy++)
      if (in->depth==16)
        out_short[x+ out->x_size*y]=in_short[xx+in->x_size*yy];
      else
        out_long[x+ out->x_size*y]=in_long[xx+in->x_size*yy];
  return(EXIT_SUCCESS);
}

int copyFrame(CCD_FRAME *dst, CCD_FRAME *src)
{
  int ii;
  for ( ii=0; ii< 4; ii++)
    dst->crop[ii] = src->crop[ii];
  dst->x_size=src->x_size;
  dst->y_size=src->y_size;
  dst->depth=src->depth;
  dst->quality=src->quality;
  dst->sequence=src->sequence;
  dst->subsequence=src->subsequence;
  dst->integration_time=src->integration_time;
  dst->start_time=src->start_time;
  dst->stop_time=src->stop_time;  
  dst->numFrames=src->numFrames;
  dst->hkvals=src->hkvals;

  if (src->run != NULL){
    if (dst->run ==0) dst->run=(char *)calloc(128,1);
    strcpy(dst->run,src->run);
  }
  if (src->cameratype != NULL){
    if (dst->cameratype==0)  dst->cameratype=(char *)calloc(128,1);
    strcpy(dst->cameratype,src->cameratype);
  }
  if (src->command != NULL){
    if (dst->command==0)  dst->command=(char *)calloc(strlen(src->command)+1,1);
    strcpy(dst->command,src->command);
  }
  dst->image=src->image;
  free_centroids(dst->cen);
  dst->cen = 0;
  add_centroids(dst,src->cen);
  return(0);
}

int print_CCD_FRAME(FILE *s, CCD_FRAME *f)
{
  if (s == NULL)
    s = stdout;
  fprintf(s,"Frame %d.%d from %s.\n", f->sequence,f->subsequence,f->run);
  fprintf(s,"Size: %ld X %ld, %d-bits\n", f->x_size, f->y_size, f->depth);
  fprintf(s,"Quality: %d\n", f->quality);
  fprintf(s,"Integration Time %.2lf\n",f->integration_time);
  fprintf(s,"Startime %s\n",asctime(gmtime(&f->start_time)));
  fprintf(s,"Stoptime %s\n",asctime(gmtime(&f->stop_time)));
  fprintf(s,"Camera: %s.\n\n", f->cameratype);
  fprintf(s,"Centroids:\n");
  if (f->cen == NULL)
    fprintf(s,"None\n");
  else
    print_centroids(f->cen,s);
  return(0);
}


int unscramble(CCD_FRAME *in, CCD_FRAME *out, uint16_t *colmap,int extra)
{
  int row, pixel;
  int x, y;
  int16_t *indata;
  int16_t *outdata;
  int col;
  int ii=0;
  strcpy(out->run, in->run);
  strcpy(out->cameratype, in->cameratype);
  strcpy(out->command, in->command);
  out->numFrames = in->numFrames;
  out->quality = in->quality;
  out->sequence = in->sequence;
  out->subsequence = in->subsequence;
  out->integration_time = in->integration_time;
  out->start_time = in->start_time;
  out->stop_time = in->stop_time;
  out->hkvals = in->hkvals;
  if (out->image == 0)
    out->image = calloc(in->x_size*in->y_size,sizeof(int16_t));
  outdata = (int16_t *)out->image;
  indata = (int16_t *)in->image;
  out->depth = in->depth;
  if (extra == -1){ // no unscrambling
    out->x_size = in->x_size; 
    out->y_size = in->y_size;
    for (pixel =0 ; pixel <  in->x_size*in->y_size; pixel++)
      outdata[pixel] = indata[pixel];
  }
  if (extra == 1) {// unscamble with ancillary
    out->x_size = in->x_size /2;
    out->y_size = in->y_size *2;
    for (row =0; row < in->y_size; row++){
      for (col = 0; col < in->x_size; col++){
	if((colmap[col] >> 15 ) ==1)
	  y = out->y_size -1 -row;
	else
	  y = row;
	x = colmap[col] & 0x3fff;
	//	fprintf(stderr,"x: %d y: %d ii: %d data: %u\n",x,y,ii,indata[ii]);
	outdata[y*out->x_size+x] =  indata[ii++];
      }
    }
  }
  if (extra == 0) {// unscamble without ancillary
    out->x_size = 4096;
    out->y_size = 4096;
    for (row =0; row < in->y_size; row++){
      for (col = 0; col < in->x_size; col++){
	if((colmap[col] & 0x8000 ) == 0x8000)
	  y = out->y_size -1 -row;
	else
	  y = row;
	if ((colmap[col] & 0x4000)  == 0x4000)  // Bit 14 is ancillary flag
	  ii++;
	else{
	  x = colmap[col] & 0x3fff;
	//	fprintf(stderr,"x: %d y: %d ii: %d data: %u\n",x,y,ii,indata[ii]);
	  outdata[y*out->x_size+x] =  indata[ii++];
	}
      }
    }
  }
  return 0;
}

int read_colmap(const char *name, uint16_t *table){
  FILE *fd;
  size_t ii;
  char newname[256];
  if (table == NULL)
    table = (uint16_t * )calloc(8544,sizeof(uint16_t));
  if (table == NULL){
    fprintf(stderr,"unable to allocate memory for colmap\n");
    return 1;
  }
  if ((fd = fopen(name, "r")) == NULL){
    sprintf(newname,"/opt/Data/TESS/Config/%s",name);
    if ((fd = fopen(newname, "r")) == NULL){
      fprintf(stderr, "failed to open colmap file %s\n", name);
      return 3;
    }
  }
  ii = fread(table, sizeof(uint16_t), 8544, fd);
  if (ii != 8544){
    fprintf(stderr, "only read %d bytes from colmap file\n", (int) ii);
    return 2;
  }
  return 0;
}
