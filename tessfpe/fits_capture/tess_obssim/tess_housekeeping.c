/*
 */


#include "tess_housekeeping.h"
#include <stdio.h>
#include <stdlib.h>

CAMERA_HK_DEFS *readHKdefs(char *fname)
{
  FILE *fd;
  int ii=0, kk;
  char HKname[32];
  char func;
  char fmt[16];
  char pname[128];
  double dd;
  CAMERA_HK_DEF *d;
  CAMERA_HK_DEFS *HK;

  HK = (CAMERA_HK_DEFS *) malloc(sizeof(CAMERA_HK_DEFS));

  fd = fopen(fname , "r");
  if (fd == NULL){
    sprintf(pname,"/opt/Data/TESS/Config/%s",fname);
    fd = fopen(pname , "r");    
    if (fd == NULL){
      fprintf(stderr,"Unable to open TESS HK config file %s\n", fname);
      return(NULL);
    }
  }
  while (fscanf(fd, "%d %d %s %d %c %lf %lf %lf %lf %lf %lf %lf %lf %s", 
	       &kk, &kk, HKname, &kk, &func, &dd, &dd, &dd, &dd, &dd, &dd, &dd, &dd, fmt) == 14)
    ii++;
  fprintf(stderr,"Number of table entries is %d\n",ii);
  HK->numDefs = ii;
  HK->defs = (CAMERA_HK_DEF **)calloc(ii,sizeof(CAMERA_HK_DEF*));
  rewind(fd);
  for (ii=0; ii< HK->numDefs; ii++){
    d = (CAMERA_HK_DEF *) calloc(1,sizeof(CAMERA_HK_DEF));
    HK->defs[ii]=d;
    d->name = (char *) calloc(1, 32);
    d->format = (char *) calloc(1, 16);
    if (fscanf(fd, "%d %d %s %d %c %lf %lf %lf %lf %lf %lf %lf %lf %s", 
	       &d->index, &d->group, d->name,  &d->WriteToHeader, &d->func, d->P, d->P +1, d->P +2,d->P+3,
	       d->Limits, d->Limits +1, d->Limits +2, d->Limits +3, d->format) != 14){
      fprintf(stderr,"Unable to read TESS HK config file %s\n", fname);
      return(NULL);
    }
  }
  return(HK);
}
      

double convertHK(uint16_t value, CAMERA_HK_DEFS *HK, int index, int group)
{
  int ii;
  double x,y;
  x = (double) twosC2int(value);
  ii=findHKindex(HK, index,group);
  if (ii >= 0){
    y = HK->defs[ii]->P[0];
    y += HK->defs[ii]->P[1] *x;
    y += HK->defs[ii]->P[2] *x*x;
    y += HK->defs[ii]->P[3] *x*x*x;
    return(y);
  } else{
    fprintf(stderr, "index %d and group %d are not listed\n",index,group);
    return(-9.e99);
  }
}


  
int twosC2int(uint16_t val){
  int ff;
  if (val & 0x8000){
    ff= (val & 0x7fff) - 0x8000;
    /*
    ff=~ii;
    ff++;
    ff *=-1;
    */
  }else
    ff=val;
  //  printf("2c 0x%x %d \n", val, ff);
  return ff;
}

int  findHKindex( CAMERA_HK_DEFS *HK, int index, int group)
{
  int ii=0;
  while (ii < HK->numDefs){
    if (index == HK->defs[ii]->index)
      if (group == HK->defs[ii]->group)
	return ii;
    ii++;
  }
  return(-1);
}
