all:
	pdflatex 2014-nips-deep-da
	bibtex 2014-nips-deep-da
	pdflatex 2014-nips-deep-da
	pdflatex 2014-nips-deep-da
bib:
	bibtex 2014-nips-deep-da

once:
	pdflatex 2014-nips-deep-da

clean:
	rm *.pdf *.out *.brf *.aux *.log *.blg *.bbl
