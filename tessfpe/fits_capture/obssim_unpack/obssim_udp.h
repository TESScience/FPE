#ifndef obssim_udp_h
#define obssim_udp_h 1

#include <sys/types.h>
#include <stdint.h>

/*! \brief Reader state variables */
/*! \brief Reader state variables */
typedef struct 
{
  uint16_t *imagebuf; /**< Single frame image buffer */
  int sock;	      /**< UDP socket */
  size_t pixelcnt;    /**< # pixels in a frame */
  ssize_t frameno;    /**< current frame number or -1 if no frame yet */
  size_t index;	      /**< current pixel in frame */
  size_t houselen;    /**< Number of bytes in housekeeping */
  uint16_t *housebuf; /**< Housekeeping buffer (256 values) */
  size_t pktcnt;      /**< Number of packets received since Start of Frame */
} OBSSIM_READER;



void reader_close(OBSSIM_READER *reader);
int reader_init(OBSSIM_READER *reader,
		const char *ipaddr,
		int port,
		size_t pixelcnt);
ssize_t reader_readimage(OBSSIM_READER *reader);
int reader_writefile(OBSSIM_READER *reader, const char *prefix);
int reader_writehk(OBSSIM_READER *reader, const char *prefix);

#endif /* obssim_udp_h */
