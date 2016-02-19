extern "C" {

#include <string.h>
#include <strings.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/socket.h>
#include <errno.h>
#include <stdlib.h>

#define main obssim_unpack_main
  int obssim_unpack_main(int argc, char **argv);

#define strdup stub_strdup
  char *stub_strdup(const char *define);

#define malloc stub_malloc
  void *stub_malloc(size_t size);

#define write stub_write
  ssize_t stub_write(int fd, const void *buf, size_t nbyte);

#define socket stub_socket
  int stub_socket(int domain, int type, int protocol);

#define recv stub_recv
     ssize_t stub_recv(int socket, void *buffer, size_t length, int flags);

#include "obssim_unpack.c"
#include "obssim_udp_main.c"

#undef main
#undef malloc
#undef write
#undef socket
#undef recv

};

#include <gtest/gtest.h>

int stub_mallocerr = 0;
void *stub_malloc(size_t size)
{
  if (stub_mallocerr) {
    errno = ENOMEM;
    return 0;
  }
  return malloc(size);
}

ssize_t stub_writeerr = 0;
ssize_t stub_write(int fd, const void *buf, size_t nbyte)
{
  if (stub_writeerr == 0)
    return write(fd, buf, nbyte);
  else
    return stub_writeerr;
}

ssize_t stub_socketerr = 0;
int stub_socket(int domain, int type, int protocol)
{
  if (stub_socketerr == 0)
    return socket(domain, type, protocol);
  else
    return stub_socketerr;
}

int stub_recvflag = 0;
ssize_t stub_recverr[5] = { -1, -1, -1, -1, -1 };
char stub_recvdata[5][80];

ssize_t stub_recv(int socket, void *buffer, size_t length, int flags)
{
  if (stub_recvflag > 0) {
    if (length > 80)
      length = 80;
    memcpy(buffer, stub_recvdata[stub_recvflag], length);
    return stub_recverr[stub_recvflag--];
  }
  else {
    return recv(socket, buffer, length, flags);
  }
}

class Test_obssim_unpack : public ::testing::Test {
protected:
  virtual void SetUp() {
    mkdir("test",0777);

    stub_mallocerr = 0;
    stub_writeerr = 0;
    stub_socketerr = 0;
    stub_recvflag = 0;
  };

  virtual void TearDown() {
    unlink("./test/test-obssim-0.bin");
    unlink("./test/test-obssim-1.bin");
    rmdir("test");
  };

  void filematch(const char *filename,
		 const uint8_t *buf,
		 size_t buflen)
  {
    FILE *fp = fopen(filename, "r");
    ASSERT_NE((FILE *) 0, fp);

    for (size_t ii = 0; ii < buflen; ii++)
      if (buf[ii] != fgetc(fp))
	fprintf(stderr, "Mismatch byte %d\n", (int) ii);

    rewind(fp);

    while (buflen--)
      ASSERT_EQ(*buf++, fgetc(fp));

    ASSERT_EQ(-1, fgetc(fp));
    fclose(fp);
  }
};

TEST_F(Test_obssim_unpack, main_usage)
{
  char progname[] = "./obssim_unpack";
  char *argv[] = {
    progname
  };

  ASSERT_EQ(-1, obssim_unpack_main(1, argv));
}

TEST_F(Test_obssim_unpack, main_initerr)
{
  char progname[] = "./obssim_unpack";
  char prefix[] = "./test/test-";
  char ipaddr[] = "127.0.0.1";
  char port[] = "5555";
  char pixelcnt[] = "17756160";
  char *argv[] = {
    progname,
    prefix,
    ipaddr,
    port,
    pixelcnt
  };

  stub_mallocerr = 1;
  ASSERT_EQ(-1, obssim_unpack_main(5, argv));
}

TEST_F(Test_obssim_unpack, main_readerr)
{
  char progname[] = "./obssim_unpack";
  char prefix[] = "./test/test-";
  char ipaddr[] = "127.0.0.1";
  char port[] = "5555";
  char pixelcnt[] = "17756160";
  char *argv[] = {
    progname,
    prefix,
    ipaddr,
    port,
    pixelcnt
  };

  stub_recvflag = 1;
  stub_recverr[1] = -1;

  ASSERT_EQ(0, obssim_unpack_main(5, argv));
}

TEST_F(Test_obssim_unpack, main_writeerr)
{
  char progname[] = "./obssim_unpack";
  char prefix[] = "./test/test-";
  char ipaddr[] = "127.0.0.1";
  char port[] = "5555";
  char pixelcnt[] = "17756160";
  char *argv[] = {
    progname,
    prefix,
    ipaddr,
    port,
    pixelcnt
  };

  /* fake frame in one packet */
  stub_recvflag = 2;
  stub_recverr[2] = sprintf(stub_recvdata[2], "1 : Starting Frame - 0\n");
  stub_recverr[1] = atoi(pixelcnt) * sizeof(uint16_t);

  /* prevent a successful write by removing directory */
  rmdir("./test");

  ASSERT_EQ(0, obssim_unpack_main(5, argv));
}

TEST_F(Test_obssim_unpack, main_writeok)
{
  char progname[] = "./obssim_unpack";
  char prefix[] = "./test/test-";
  char ipaddr[] = "127.0.0.1";
  char port[] = "5555";
  char pixelcnt[] = "17756160";
  char *argv[] = {
    progname,
    prefix,
    ipaddr,
    port,
    pixelcnt
  };

  /* fake frame in one packet */
  stub_recvflag = 3;
  stub_recverr[3] = sprintf(stub_recvdata[3], "1 : Starting Frame - 0\n");
  stub_recverr[2] = atoi(pixelcnt) * sizeof(uint16_t);
  stub_recvdata[2][0] = 0;
  stub_recverr[1] = -1;
  stub_recvdata[1][0] = 0;

  ASSERT_EQ(0, obssim_unpack_main(5, argv));
}

TEST_F(Test_obssim_unpack, init_mallocerr)
{
  OBSSIM_READER reader;

  ASSERT_EQ(-1, reader_init(&reader, "127.0.0.1", 5555, -1));
}

TEST_F(Test_obssim_unpack, init_socketerr)
{
  OBSSIM_READER reader;

  stub_socketerr = -1;
  ASSERT_EQ(-1, reader_init(&reader, "127.0.0.1", 5555, 1024));
}

TEST_F(Test_obssim_unpack, init_binderr)
{
  OBSSIM_READER reader1;
  OBSSIM_READER reader2;

  /* try to bind to same port twice on same interface */
  ASSERT_EQ(0, reader_init(&reader1, "127.0.0.1", 5555, 1024));
  ASSERT_EQ(-1, reader_init(&reader2, "127.0.0.1", 5555, 1024));

  reader_close(&reader1);
}

TEST_F(Test_obssim_unpack, read_recverr)
{
  /* covered by earlier test */
  SUCCEED();
}

TEST_F(Test_obssim_unpack, read_startframe)
{
  /* covered by earlier test */
  SUCCEED();
}

TEST_F(Test_obssim_unpack, read_shortframe)
{
  OBSSIM_READER reader;

  ASSERT_EQ(0, reader_init(&reader, "127.0.0.1", 5555, 1024));

  /* fake frame in one packet */
  stub_recvflag = 4;
  stub_recverr[4] = sprintf(stub_recvdata[4], "1 : Starting Frame - 0\n");

  stub_recverr[3] = reader.pixelcnt;
  stub_recvdata[3][0] = 0;

  stub_recverr[2] = sprintf(stub_recvdata[2], "2 : Starting Frame - 1\n");

  stub_recverr[1] = -1;
  stub_recvdata[1][0] = 0;

  ASSERT_EQ(-1, reader_readimage(&reader));

  reader_close(&reader);
}

TEST_F(Test_obssim_unpack, read_garbage)
{
  OBSSIM_READER reader;

  ASSERT_EQ(0, reader_init(&reader, "127.0.0.1", 5555, 1024));

  /* fake frame in one packet */
  stub_recvflag = 4;

  stub_recverr[4] = reader.pixelcnt;
  stub_recvdata[4][0] = 0;

  stub_recverr[3] = sprintf(stub_recvdata[3], "1 : Starting Frame - 0\n");

  stub_recverr[2] = reader.pixelcnt * sizeof(uint16_t);
  stub_recvdata[2][0] = 0;

  stub_recverr[1] = -1;
  stub_recvdata[1][0] = 0;

  ASSERT_EQ(1024, reader_readimage(&reader));

  reader_close(&reader);
}

TEST_F(Test_obssim_unpack, write_ok)
{
  /* covered by previous test */
  SUCCEED();
}

TEST_F(Test_obssim_unpack, write_err)
{
  OBSSIM_READER reader;

  ASSERT_EQ(0, reader_init(&reader, "127.0.0.1", 5555, 1024));

  stub_writeerr = -1;
  ASSERT_EQ(-1, reader_writefile(&reader, "./test"));

  reader_close(&reader);
}

TEST_F(Test_obssim_unpack, write_short)
{
  OBSSIM_READER reader;

  ASSERT_EQ(0, reader_init(&reader, "127.0.0.1", 5555, 1024));

  stub_writeerr = 1023;
  ASSERT_EQ(0, reader_writefile(&reader, "./test"));

  reader_close(&reader);
}

int main(int argc, char** argv) {

  ::testing::InitGoogleTest(&argc, argv);

  int result = RUN_ALL_TESTS();
  
  return result;
}

