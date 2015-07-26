#!gmake

# Programs used to build the pdf and HTML5 output.
LATEX=xelatex
LATEXMLC=latexmlc
UNZIP=unzip
WGET=wget

# URLs of style and font dependencies.
W3C_REC_CSS=http://www.w3.org/StyleSheets/TR/W3C-REC.css
MATHML_FONTS=https://github.com/fred-wang/MathFonts/archive/gh-pages.zip

all: pdf html

clean:
	rm -f *~; rm -f */*~; rm -f */*/*~
	cd output; rm -f *.aux *.log *.toc *.out

distclean: clean
	rm -rf output

pdf:
	mkdir -p output
	cd source && \
	$(LATEX) -output-directory ../output/ index.tex

output/W3C-REC.css:
	mkdir -p output
	$(WGET) $(W3C_REC_CSS) -O $@
	touch $@

output/style.css: source/style.css
	mkdir -p output
	cp $< $@

output/math-fonts.zip:
	mkdir -p output
	$(WGET) $(MATHML_FONTS) -O $@
	touch $@

output/webfonts/GUST-FONT-LICENSE.txt: output/math-fonts.zip
	mkdir -p output/webfonts
	$(UNZIP) -j -d output/webfonts $< \
                MathFonts-gh-pages/LatinModern/*.woff \
		MathFonts-gh-pages/LatinModern/GUST-FONT-LICENSE.txt
	touch $@

html: output/W3C-REC.css output/style.css output/webfonts/GUST-FONT-LICENSE.txt
	cd source; \
	$(LATEXMLC) --dest ../output/index.html \
                    --format=html5 --pmml --mathtex \
                    --css=style.css --splitat=section index.tex

.PHONY: clean distclean pdf html
