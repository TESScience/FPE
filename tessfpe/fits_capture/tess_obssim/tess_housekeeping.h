//
//  Structs and definitions for interpretting TESS camera HK values
//

#ifndef __TESS_HK
#define __TESS_HK

#include <stdint.h>

#define NUM_CAMERA_HK_VALS 64


typedef struct {
  int index;
  int group;
  char *name;
  int  WriteToHeader;
  char func;
  double P[4];
  double Limits[4];
  char *format;
} CAMERA_HK_DEF;


typedef struct {
  int numDefs;
  CAMERA_HK_DEF **defs;
} CAMERA_HK_DEFS;

CAMERA_HK_DEFS* readHKdefs(char *fname);
int  findHKindex( CAMERA_HK_DEFS *HK, int index, int group);
double convertHK(uint16_t value, CAMERA_HK_DEFS *HK, int index, int group);
int twosC2int(uint16_t val);
#endif    
