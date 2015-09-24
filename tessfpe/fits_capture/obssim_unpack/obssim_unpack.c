/*! 
 *  \file obssim_unpack.c
 *
 */
#include <sys/types.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>

#include <sys/socket.h>
#include <arpa/inet.h>

#include <assert.h>
#include "obssim_udp.h"

/*! \brief Release reader resources
 *
 *  \details
 *  If image buffer allocated, free it; if housekeeping allocated, free it;
 *  if UDP open, close it.
 *
 *  \param reader Reader state variables
 */
void reader_close(OBSSIM_READER *reader)
{
  if (reader->sock >= 0)
    close(reader->sock);
  reader->sock = -1;

  if (reader->imagebuf != 0)
    free(reader->imagebuf);
  reader->imagebuf = 0;

  if (reader->housebuf != 0)
    free(reader->housebuf);
  reader->housebuf = 0;
}
 
/*! \brief Initialize reader structure and open the UDP port
 *
 *  \details
 *  Allocates an image buffer, opens the UDP port and initializes
 *  its state variables.
 *
 *  \param reader Reader state structure
 *  \param prefix Filename prefix includeing path (i.e. "./frames/foo-")
 *  \param ipaddr Local IP address of ethernet port connected to obs sim
 *  \param port UDP port number
 *  \param pixelcnt Pixels per frame
 *
 *  \returns 0 on success, otherwise negated error code
 */
int reader_init(OBSSIM_READER *reader,
		const char *ipaddr,
		int port,
		size_t pixelcnt)
{
  struct sockaddr_in inaddr;

  reader->imagebuf = 0;
  reader->housebuf = 0;
  reader->sock = -1;

  /* allocate image buffer + 1 byte for null termination */
  reader->imagebuf = (uint16_t *) malloc(pixelcnt * sizeof(uint16_t) + 1);

  if (reader->imagebuf == 0) {
    perror("malloc");
    reader_close(reader);	/* release resources */
    return -1;
  }

  /* allocate housekeeping buffer */
  reader->houselen = 256 * sizeof(uint16_t);
  reader->housebuf = (uint16_t *) malloc(reader->houselen);

  if (reader->housebuf == 0) {
    perror("malloc");
    reader_close(reader);	/* release resources */
    return -1;
  }

  /* open UDP port */
  reader->sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if (reader->sock < 0) {
    perror("socket");
    reader_close(reader);	/* release resources */
    return -1;
  }

  inaddr.sin_family = AF_INET;
  inaddr.sin_port = htons(port);
  inet_aton(ipaddr, &inaddr.sin_addr);

  if (bind(reader->sock, (struct sockaddr *) &inaddr, sizeof(inaddr)) < 0) {
    perror("bind");
    reader_close(reader);	/* release resources */
    return -1;
  }

  /* initialize remaining instance state variables */
  reader->pixelcnt = pixelcnt;
  reader->frameno = -1;
  reader->index = 0;

  return 0;
}

/*! \brief Wait for and read an image frame into the image buffer
 *
 *  \details
 *  Reads and discards packets until we receive a "Start Frame"
 *  packet, then accumulate pixels into the image buffer until
 *  the pixel count is read. If we receive housekeeping, store it
 *  in the housekeeping buffer (regardless of whether or not we've
 *  received a start frame).
 *
 *  \param reader Reader state variables
 *
 *  \returns Number of pixels read into the image buffer, or -1 on error
 */
ssize_t reader_readimage(OBSSIM_READER *reader)
{
  uint8_t *ptr;
  size_t size;
  int nr;
  int time;
  int frame;
  static int scanning_msg = 0;

  /* wait for a new start of frame */
  reader->index = 0;
  reader->pktcnt = 0;
  reader->frameno = -1;

  /* while not a full frame */
  while (reader->index < reader->pixelcnt) {

    /* setup pointer and room remaining in image buffer */
    ptr = (uint8_t *) &reader->imagebuf[reader->index];
    size = (reader->pixelcnt - reader->index) * sizeof(reader->imagebuf[0]);

    /* read a packet */
    nr = recv(reader->sock, ptr, size, 0);
    
    if (nr < 0) {
      perror("recv");
      return -1;
    }

    reader->pktcnt++;
    ptr[nr] = '\0';		/* null terminate */

    /* check for a start of frame */
    if (sscanf((const char *) ptr,
	       "%d : Starting Frame - %d\n",
	       &time, &frame) == 2) {

      scanning_msg = 0;

      if (reader->index != 0) {
	fprintf(stderr, "short frame %d : Starting Frame - %d index = %d\n",
		time, frame, (int)reader->index);
      }
      else {
	fprintf(stderr, "%d : Starting Frame - %d\n", time, frame);
      }
      reader->index = 0;
      reader->frameno = frame;	/* set the frame number enabling pixel */
      reader->pktcnt = 0;
      /* next packet will overwrite this data in the image buffer */
    }
    else if ((nr >= (int)(strlen("Housekeeping")+(size_t) reader->houselen)) &&
	     (memcmp((const char *) ptr,
		     "Housekeeping",
		     strlen("Housekeeping")) == 0)) {
      fprintf(stderr, "Housekeeping\n");
      memcpy(reader->housebuf,
	     ptr + strlen("Housekeeping"),
	     reader->houselen);
    }
    else if (reader->frameno >= 0) {

      /* advance by # pixels read */
      reader->index += nr / sizeof(reader->imagebuf[0]);
    }
    else {
      /* no frame yet, toss the packet */
      if (!scanning_msg) {
	fprintf(stderr, "scanning for start of frame ...");
	fflush(stderr);
	scanning_msg = 1;
      }
    }
  }

  return reader->index;
}

/*! \brief Write image to file
 *
 *  \details
 *  Write a read image to file, using the prefix as the
 *  base directory/filename specifier.
 *
 *  \param reader Reader state variables containing the image
 *
 *  \return 0 on success, -1 on error
 */
int reader_writefile(OBSSIM_READER *reader, const char *prefix)
{
  char filename[80];
  int fd;
  size_t wrlen;
  ssize_t nr;

  snprintf(filename, sizeof(filename),
	   "%s%s-%d.bin", prefix, "obssim", (int)reader->frameno);

  fprintf(stderr, "writing file %s\n", filename);

  fd = open(filename, O_CREAT | O_WRONLY, 0666);

  if (fd < 0) {
    perror(filename);
    return -1;
  }

  wrlen = reader->index * sizeof(reader->imagebuf[0]);

  nr = write(fd, reader->imagebuf, wrlen);

  if (nr < 0) {
    perror("write");
    return -1;
  }

  if (nr != (ssize_t) wrlen)
    fprintf(stderr, "warn: short write %d, expected %d\n",
	    (int) nr, (int) wrlen);

  close(fd);

  return 0;
}

/*! \brief Write housekeeping to file
 *
 *  \details
 *  Write read housekeeping to file, using the prefix as the
 *  base directory/filename specifier.
 *
 *  \param reader Reader state variables containing the housekeeping
 *  \param prefix Prefix to generated filenames
 *  \return 0 on success, -1 on error
 */
int reader_writehk(OBSSIM_READER *reader, const char *prefix)
{
  char filename[80];
  int fd;
  ssize_t nw;

  snprintf(filename, sizeof(filename),
	   "%s%s-%d.bin", prefix, "obssim-hk", (int)reader->frameno);

  fprintf(stderr, "writing file %s\n", filename);

  fd = open(filename, O_CREAT | O_WRONLY, 0666);

  if (fd < 0) {
    perror(filename);
    return -1;
  }

  nw = write(fd, reader->housebuf, reader->houselen);

  if (nw < 0) {
    perror("write");
    return -1;
  }

  if (nw != (ssize_t) reader->houselen)
    fprintf(stderr, "warn: short write %d, expected %d\n",
	    (int) nw, (int) reader->houselen);

  close(fd);

  return 0;
}

