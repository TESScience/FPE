#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tess_notes.h"
#include "tess_guidestamps.h"

void do_stuff()
{
  //if (save_images) fprintf(stderr,"Saving image %s_%d\n",rootname,image_counter++);
}


int check_for_note()
{
  FILE *fp;
  char line[300],rm[300],key[50];
  int n=0,retval;

  sprintf(rm,"rm %s",NOTE_NAME);

  // fprintf(stderr,"Checking for a note!\n");
  fp = fopen(NOTE_NAME,"r");
  if (fp == NULL) return(NO_NOTE);
  //  fprintf(stderr,"Received a note; how nice!\n");


  while (fgets(line,300,fp) != NULL)
    {
      line[strlen(line)-1] = 0;
      n++;
      //  fprintf(stderr,"Line %d is %s\n",n,line);
      if (!strncmp(line,"DIE",3)) 
	{
	  fprintf(stderr,"Will quit after reading the note\n");
	  retval = DIE;
	}
      else if (!strncmp(line,"XOFFSET",7)) 
	{
	  sscanf(line,"%s %lf",key,&ss_Xoffset);
	  fprintf(stderr,"Setting X offset to %f\n",ss_Xoffset);
	  // ss_Xoffset = 0.0;
	  retval |= SET_XOFFSET;
	}
      else if (!strncmp(line,"YOFFSET",7)) 
	{
	  sscanf(line,"%s %lf",key,&ss_Yoffset);
	  fprintf(stderr,"Setting Y offset to %f\n",ss_Yoffset);
	  // ss_Yoffset = 0.0;
	  retval |= SET_YOFFSET;
	}
      else if (!strncmp(line,"ROOT",4)) 
	{
	  sscanf(line,"%s %s",key,note_newroot);
	  fprintf(stderr,"Setting rootname to %s\n",note_newroot);
	  retval |= RENAME_ROOT;
	}
      else if (!strncmp(line,"SAVE",4)) 
	{
	  retval |= WRITE_FITS | CHANGE_WRITE_FITS;
	  fprintf(stderr,"Beginning image save\n");
	}
      else if (!strncmp(line,"NOSAVE",6)) 
	{
	  retval &= ~WRITE_FITS;
	  retval |= CHANGE_WRITE_FITS;
	  fprintf(stderr,"Pausing image save\n");
	}
      else if (!strncmp(line,"READ_KEYS",9)) 
	{
	  retval |= READ_KEYWORDS;
	  fprintf(stderr,"rereading the keywords file\n");
	}
      else if (!strncmp(line,"RESET_COUNTER",9)) 
	{
	  retval |= RESET_COUNTER;
	  fprintf(stderr,"resetting the counter file\n");
	}
      else {
	retval |= UNKNOWN_CMD;
	fprintf(stderr,"unintelligable note %s\n",line);
      }
    }
  fclose(fp);
  system(rm);
  if (n == 0) retval = GOT_EMPTY_NOTE;
  return(retval);
}

int read_keywords(char *filename,CCD_FRAME *F1, CCD_FRAME *F2, CCD_FRAME *F3)
{
  int ii;
  FILE *keyWordFile;
  char *keyword, *keyvalue;
  if (filename[0] == 0) return(0);

  if ((keyWordFile = fopen(filename,"r")) == NULL){
    fprintf(stderr,"Unable to open keyword file %s.\n",filename);
    return(0);
  }
  if (F1 == 0){
    fprintf(stderr,"No CCD_FRAME passed to read_keywords.\n");
    return(1);
  }
  if (F1->numkeys > 0){
    for (ii=0; ii<F1->numkeys; ii++){
      free(F1->keyword[ii]);
      free(F1->keyvalue[ii]);
    }
    free(F1->keyword);
    free(F1->keyvalue);
  }
  if (F2 != 0)
    if (F2->numkeys > 0){
      for (ii=0; ii<F2->numkeys; ii++){
	free(F2->keyword[ii]);
	free(F2->keyvalue[ii]);
      }
      free(F2->keyword);
      free(F2->keyvalue);
    }
  if (F3 != 0)
    if (F3->numkeys > 0){
      for (ii=0; ii<F3->numkeys; ii++){
	free(F3->keyword[ii]);
	free(F3->keyvalue[ii]);
      }
      free(F3->keyword);
      free(F3->keyvalue);
    }
    
  keyword = (char *) calloc(12,sizeof(char));
  keyvalue = (char *) calloc(68,sizeof(char));
  ii=0;
  while (fscanf(keyWordFile,"%s %s", keyword, keyvalue) == 2)
    ii++;
  F1->numkeys= ii;
  F1->keyword = (char **)calloc(ii, sizeof(char *)); 
  F1->keyvalue = (char **)calloc(ii, sizeof(char *));
  if (F2 != 0){
    F2->numkeys= ii;
    F2->keyword = (char **)calloc(ii, sizeof(char *));
    F2->keyvalue = (char **)calloc(ii, sizeof(char *));
  }
  if (F3 != 0){
    F3->numkeys= ii;
    F3->keyword = (char **)calloc(ii, sizeof(char *));
    F3->keyvalue = (char **)calloc(ii, sizeof(char *));
  }
  fseek(keyWordFile,0,SEEK_SET);
  for (ii = 0 ; ii < F1->numkeys ; ii++){
    fscanf(keyWordFile,"%s %s", keyword, keyvalue);

    F1->keyword[ii] = keyword;
    F1->keyvalue[ii] = keyvalue;
    if (F2 != 0){
      F2->keyword[ii] = keyword;
      F2->keyvalue[ii] = keyvalue;
    }
    if (F3 != 0){
      F3->keyvalue[ii] = keyvalue;
      F3->keyword[ii] = keyword;
    }
    keyword = (char *) calloc(12,sizeof(char));
    keyvalue = (char *) calloc(68,sizeof(char));
  }
  return(0);
}
