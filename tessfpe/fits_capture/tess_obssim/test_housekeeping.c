/*
 */

#include <stdio.h>
#include <stdlib.h>
#include "tess_housekeeping.h"

int main (int argc, char **argv)
{
  int group, index, value;
  CAMERA_HK_DEFS *hkdefs;
  char fname[64] = "CAMERA_HK.tbl";
  double dd;
  hkdefs = readHKdefs(fname);
  while (scanf("%d %d 0x%x", &group, &index, &value) == 3){
    dd=convertHK( value, hkdefs,  index,  group);    
    printf("%d 0x%x %lf\n", value, value, dd);
    fflush(stdout);
  }
  exit(EXIT_SUCCESS);
}
