#ifndef _TESSGS_H
#define _TESSGS_H

#include <stdio.h>
#include "tess_camlink.h"

#define SATURATION 32500

double ss_Xoffset,ss_Yoffset;

typedef struct {
  char id[16];
  double x;
  double y;
  int min;
  int max;
  int fits;
  int NoACS;
  double flux;
  double background;
  double fitx;
  double fity;
} GuideStamp;

typedef struct {
  unsigned int number;
  unsigned short xsize;
  unsigned short ysize;
  GuideStamp *stamps;
} GuideStampList;


float centroidGuideStamps(CCD_FRAME *frame, GuideStampList *stamps,FILE *GuideStampFile);
int centroid(CCD_FRAME *frame, GuideStamp *stamp, int radius);
GuideStampList* newGuideStampList(char *filename);


#endif
