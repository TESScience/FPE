#include "gps.h"
#include <sys/time.h>
/* This function will return incorrect value before 1999.
   New leap seconds must be added as they are declared.
   This should really read tai-utc.dat, or the DB
*/
int get_leaps(time_t unixt)
{
  int leaps = 32; // Value in 1999
  if (unixt > 1136073600) leaps++; // Jan 1 2006
  if (unixt > 1230768000) leaps++; // Jan 1 2009
  if (unixt > 1341082801) leaps++; // July 1 2012

  return (leaps);
}

double gps_now()
{
  struct timeval tt;
  struct timezone tz;
  tz.tz_minuteswest =0;
  tz.tz_dsttime =0;
  int rc __attribute__((unused));
  double gps;
  rc = gettimeofday(&tt,&tz);
  gps = tt.tv_sec + tt.tv_usec*1.e-6 - GPSEPOCH  +get_leaps(tt.tv_sec);
  return (gps);
}
