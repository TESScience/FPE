//========================================================================
// Name:     tess_fits.h
// Author:   Ed Morgan
//
// Code for writing TESS fits files.
//
//=======================================================================

#ifndef _TESSFITS_H
#define _TESSFITS_H

#include <fitsio.h>
#include "tess_camlink.h"
#include "tess_guidestamps.h"
/*
typedef struct {
  char field[10];
  char data[70];
} fits_header_entry
*/

/********************************************************
*       for fitsio error log                            *
********************************************************/
//#define FITS_GET_MEMORY char *error_log; error_log = (char *) malloc(FLEN_ERRMSG);
#define FITS_GET_ERROR    if( fits_st != 0 ) {\
  ffgerr(fits_st, error_log);\
  fprintf(stderr, "Status code is %d\nERROR::%s\n", fits_st, error_log);\
  return 0;\
}
#define FITS_CHECK_ERROR(x)     if( (x) > 0 ) {\
  ffgerr (fits_status, error_log);\
  fprintf(stderr, "Status code is %d\nERROR::%s\n", fits_status, error_log);\
  return 0;\
}

int read_fits(char *, CCD_FRAME *frame);
int write_fits(CCD_FRAME *frame);
int write_stamp(CCD_FRAME *frame,GuideStamp *stamp);

#endif       // _TESSFITS_H
