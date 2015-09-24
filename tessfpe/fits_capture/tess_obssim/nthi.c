/*
  nthi.c	Adapted 9/7/90		Roland Vanderspek

  This module contains just JPD's median-determining routine nthi.
*/

#include <stdio.h>
#include <math.h>

int ixrand(int);

/* Find the nth from the minimum value in an array */
/* Monte Carlo method intended for finding medians */
/* 2/13/85 jpd */

/* For random data, this routine takes about */
/* 2.6*numdata + O( log( numdata )) comparisons */
/* If the data is tightly clustered about the mean, */
/* there is a speedup; it may take as few as */
/* 0.5*numdata comparisons. */
/* There is a slight penalty if the array is completely */
/* or partially sorted; it is at most 25%. */


int nthi( int *data, int numdata, int n )
  {
  register int boundary, thisdata;
  register int *lowp, *highp;
  int v1, v2;
  int nlowbin;

  lowp = data;			/* Init data pointer */

  v1 = data[ ixrand( numdata )];
    {
    register int v1r = v1;
    int nc = 1 + numdata - n;	/* "Complement" of n */

    if( nc > n ) highp = lowp + nc;
    else highp = lowp + n;	/* Limit to test for done */

			    /* Scan for the first point which
			       doesn't match the boundary point.
			       If we encounter enough
			       matching points,
			       the boundary is the answer */
    while( *lowp++ == v1r )
      {
      if( lowp >= highp ) 
        {
	return( v1r );
	}
      }
    v2 = *--lowp;		/* Back up to get point */
    }

  boundary = ( v1>>1 ) + ( v2>>1 );	/* Beware overflows */

  highp = data + numdata;		/* Now process the whole thing */
  thisdata = *lowp;		/* Prime the pump */

  if( v2 < v1 ) 
    {			/* Bin 2 is low bin */
    for( ; lowp < highp; thisdata = *lowp ) 
      {
      if( thisdata <= boundary ) 
        { /* Bin 2 */
	*lowp = *--highp;	/* Exchange */
	*highp = thisdata;
	} 
      else ++lowp;	/* Data point in right place */
      }

    nlowbin = numdata - ( lowp - data );
    if( nlowbin >= n ) return( nthi( highp, nlowbin, n ));
    else return( nthi( data, lowp - data, n - nlowbin ));
    } 
  else 
    {			/* Primary bin is low bin */
    for( ; lowp < highp; thisdata = *lowp )
      {
      if( thisdata > boundary ) 
	{ /* Bin 2 */
	*lowp = *--highp;	/* Exchange */
	*highp = thisdata;
	} 
      else ++lowp;	/* Don't move point */
      }

    nlowbin = ( lowp - data );
    if( nlowbin >= n ) return( nthi( data, nlowbin, n ));
    else return( nthi( highp, numdata - nlowbin, n - nlowbin ));
    }
  }

int ixrand(int n)
  {
  int random();

  return(random() % n);
  }
