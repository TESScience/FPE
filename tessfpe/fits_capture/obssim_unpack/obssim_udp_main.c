
#include <stdio.h>
#include <stdlib.h>
#include "obssim_udp.h"

static const char usage[] = 
  "Usage: obssim_unpack <prefix> <localip> <port> <pixelcnt>\n" \
  " where:\n" \
  "        <prefix> is the image file base directory and filename prefix\n" \
  "        <localip> is the local IP address assigned to the ethernet port\n" \
  "        <port> is the UDP port number to bind to\n" \
  "        <pixelcnt> number of 16-bit values (pixels/hk) in a frame\n\n";

/*! \brief Main to read and assemble images from the observatory sim
 *
 *  \details
 *  Listens for UDP packets on the observatory simulator port,
 *  assembles the pixel values in corresponding data files.
 *
 *  \param argc Number of arguments
 *  \param argv[0] program name
 *  \param argv[1] output name prefix, including directory
 *  \param argv[2] IP address of host ethernet device connected to obs sim
 *  \param argv[3] UDP port number to connect to
 *  \param argv[4] Number of pixels in a frame
 *
 *  \returns 0 on success, non-zero on error
 */
int main(int argc, char **argv)
{
  OBSSIM_READER reader;
  const char *prefix;
  const char *ipaddr;
  int port;
  size_t pixelcnt;

  if (argc < 5) {
    fprintf(stderr, "%s\n", usage);
    return -1;
  }

  prefix = argv[1];
  ipaddr = argv[2];
  port = atoi(argv[3]);
  pixelcnt = atoi(argv[4]);

  if (reader_init(&reader, ipaddr, port, pixelcnt) < 0)
    return -1;

  while (reader_readimage(&reader) >= 0) {

    if (reader_writefile(&reader,prefix) < 0)
      break;

    if (reader_writehk(&reader,prefix) < 0)
      break;
  }

  reader_close(&reader);

  return 0;
}
