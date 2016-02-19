

#include "tess_camlink.h"
#define NOTE_NAME		"tess.note"
#define NO_NOTE			0x00
#define DIE			1
#define GOT_A_NOTE		2
#define GOT_EMPTY_NOTE		4
#define RENAME_ROOT		0x08
#define WRITE_FITS	        0x100
#define CHANGE_WRITE_FITS       0x200
#define SET_XOFFSET		0x10
#define SET_YOFFSET		0x20
#define READ_KEYWORDS           0x40
#define RESET_COUNTER           0x80
#define UNKNOWN_CMD             0x8000
char note_newroot[300];
int check_for_note(void);
int read_keywords(char *filename,CCD_FRAME *F1, CCD_FRAME *F2, CCD_FRAME *F3);
