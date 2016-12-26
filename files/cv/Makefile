TEX = $(wildcard *.tex)
BIB = $(basename $(TEX))
all:
	pdflatex $(TEX)
	bibtex $(BIB)
	pdflatex $(TEX)
	pdflatex $(TEX)

clean:
	rm -f *.aux *.bbl *.log *.dvi *.ps *.blg *.out

clean-all:
	rm -f *.pdf *.aux *.bbl *.log *.dvi *.ps *.blg *.out
