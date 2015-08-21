PDFLATEX=cat /dev/null | pdflatex
SCH=../Schematic
DATA=../Data

PINTEX= CCD-51pin.tex TempConn.tex Interface.U4.tex \
	Interface.J8.tex Stack.tex

TSVTEX=BiasGroup.tex ClockDriverGroup.tex HKmap.tex \
	HeaterGroup.tex ThermalGroup.tex InterfaceGroup.tex

.PHONY: pdfs all clean

all: pdfs FPE.pdf
pdfs:
	make -C Figs

FPE.pdf : FPE.tex $(PINTEX) stamp.tex date.txt tag.tex $(wildcard Figs/*.pdf) StackMap.tex $(TSVTEX)
	$(PDFLATEX) FPE.tex
	$(PDFLATEX) FPE.tex
	$(PDFLATEX) FPE.tex

$(SCH)/%.txt:
	make -C $(SCH) $(notdir $@)

$(PINTEX) : $(patsubst %.tex, $(SCH)/%.txt, $(PINTEX))
	gawk -f pins2tex.awk < $(SCH)/$(@:.tex=.txt) >$@

$(TSVTEX) :
	gawk -f tsv2tex.awk < $(DATA)/$(@:.tex=.tsv) >$@

StackMap.tex: $(SCH)/StackMap.txt
	tr '\t' '&' < $< | sed -e 's/\\_\([^\\]*\)\\_/$$\\overline{\\textup{\1}}$$/g' \
                               -e 's/&&&/\&\\multicolumn{2}{l|}{}\&/g' \
                               -e 's/&&$$/\&\\multicolumn{2}{l|}{}/' \
                               -e 's/^&&/\\multicolumn{2}{|l|}{}\&/' \
                               -e 's/$$/\&\\\\[2ex]ⓝ\\hline/' \
                         | tr 'ⓝ' '\n' > $@

date.txt :
	git log -1 --format="%cd" > $@

stamp.tex :
	echo "Version  $(shell git describe --tags) \\\\\\\\" > $@

tag.tex :
	if [ "$(shell git describe --tags $(shell git log -1 --format="%h"))" = \
             "$(shell git describe --tags --abbrev=0 $(shell git log -1 --format="%h"))" ] ; then \
           echo "Tag $(shell git describe --tags --abbrev=0 $(shell git log -1 --format="%h")) \\\\\\\\" ; \
        fi > $@

clean :
	make -C Figs clean
	rm -f $(PINTEX) $(TSVTEX) *.out *.aux *.log stamp.tex date.txt StackMap.tex tag.tex FPE.pdf *.toc *.lof *.lot *.synctex.gz
