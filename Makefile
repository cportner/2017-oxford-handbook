### Makefile for Fertility Issues book chapter                  ###

### The reason for the weird set-up is to have MakeFile 
### in base directory and run LaTeX in the paper directory 
### without leaving all the other files in the base directory
### Pandoc has some issues, so the Word file produced is not immediately
### readable. Open the file with Word and let it fix the file.

TEXFILE = fertilityIssues-ver4
TEX  = ./paper
FIG  = ./figures
COD  = ./code
DAT  = ./data

### LaTeX part

# need to add a bib file dependency to end of next line
$(TEX)/$(TEXFILE).pdf: $(TEX)/$(TEXFILE).tex $(FIG)/totalFertilityRatesBW.pdf $(FIG)/childMortalityRatesBW.pdf $(TEX)/oxford-references.bib
	cd $(TEX); xelatex $(TEXFILE)
	cd $(TEX); bibtex $(TEXFILE)
	cd $(TEX); xelatex $(TEXFILE)
	cd $(TEX); xelatex $(TEXFILE)

.PHONY: view
view: $(TEX)/$(TEXFILE).pdf
	open -a Skim $(TEX)/$(TEXFILE).pdf & 
	
.PHONY: word
word: 
	cd $(TEX); pandoc $(TEXFILE).tex --bibliography=oxford-references.bib -S -o $(TEXFILE).docx

### R part         			                                ###
$(FIG)/totalFertilityRatesBW.pdf: $(COD)/anGraphsTFR.R $(DAT)/Data_Extract_From_World_Development_Indicators/2017-02-09-wdi-extract.csv
	cd $(COD); RScript anGraphsTFR.R

$(FIG)/childMortalityRatesBW.pdf:: $(COD)/anGraphsTFR.R $(DAT)/Data_Extract_From_World_Development_Indicators/2017-02-09-wdi-extract.csv
	cd $(COD); RScript anGraphsTFR.R


# Clean directories for (most) generated files
# This does not clean generated data files; mainly because I am a chicken
.PHONY: cleanall cleanfig cleantex cleancode
cleanall: cleanfig cleantex cleancode
	
cleanfig:
	cd $(FIG); rm *.eps; rm *.pdf rm; *.png
	
cleantex:
	cd $(TEX); rm *.aux; rm *.bbl; rm *.blg; rm *.log; rm *.out; rm *.pdf; rm *.gz
	
cleancode:	
	cd $(COD); rm *.log
	
