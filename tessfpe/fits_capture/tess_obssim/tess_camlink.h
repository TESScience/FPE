#ifndef _TESSCAMLINK_H
#define _TESSCAMLINK_H
#include <time.h>
#include "tess_housekeeping.h" 

#define FRAME_TRANSFER_TIME 0.015

typedef struct {
  double medX;
  double medY;
  double aveX;
  double aveY;
  double rmsX;
  double rmsY;
  double rms;
  int numGood;
  int numBad;
  int merit;
} POINTING_STATS;  

typedef struct {
  double x;
  double y;
  void *next;
} STAR_CENTER;

  

typedef struct {
  long x_size;
  long y_size;
  short depth;
  int numFrames;
  int quality;
  int sequence;
  int subsequence;
  int numkeys;
  double xoffset;
  double yoffset;
  char **keyword;
  char **keyvalue;
  double integration_time;
  time_t start_time;
  time_t stop_time;
  char *cameratype;
  char *run;
  void *image;
  int crop[4];
  char *command;
  STAR_CENTER *cen;
  CAMERA_HK_DEFS *hkdefs;
  uint16_t *hkvals;
} CCD_FRAME;

#endif

