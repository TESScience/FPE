//========================================================================
//
//
//
//=======================================================================

#ifndef _TESSUTILS_H
#define _TESSUTILS_H
#include "tess_camlink.h"
#include <stdint.h>

CCD_FRAME *newFrame();
int crop_image(CCD_FRAME *in, CCD_FRAME *out, int crop[4]);
int add_image(CCD_FRAME *in, CCD_FRAME *out);
int long_image(CCD_FRAME *in, CCD_FRAME *out);
int copyFrame(CCD_FRAME *dst,CCD_FRAME *src);
int print_CCD_FRAME(FILE *stream, CCD_FRAME *f);
void freeFrame(CCD_FRAME *);
STAR_CENTER* add_centroid(STAR_CENTER *c, double x, double y);
POINTING_STATS* centroid_stats(STAR_CENTER *c, POINTING_STATS *s, double max);
void add_centroids(CCD_FRAME *frame, STAR_CENTER *c);
void free_centroids(STAR_CENTER *);
int num_centroids(STAR_CENTER *);
int cmp(const void *x, const void *y);
int unscramble(CCD_FRAME *in, CCD_FRAME *out, uint16_t *table, int extra );
int read_colmap(const char *name, uint16_t *table);
#endif  // _TESSUTILS_H

