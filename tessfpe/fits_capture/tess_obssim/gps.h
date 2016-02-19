/* This is the total number of seconds between Jan 1 1970 and Jan 6 1980 including
   leap seconds */
#include <sys/time.h>
#define GPSEPOCH 1315964819

/* returns the current time in GPS seconds */
double gps_now();
void gps_jam(double);
int get_leaps(time_t);
