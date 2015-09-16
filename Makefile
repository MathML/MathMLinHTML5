#!gmake

# Programs used to build HTML5 output.
LATEXMLC=latexmlc
UNZIP=unzip
WGET=wget

# URLs of style and font dependencies.
W3C_REC_CSS=http://www.w3.org/StyleSheets/TR/W3C-REC.css
MATHML_FONTS=https://github.com/fred-wang/MathFonts/archive/gh-pages.zip

all: html

clean:
	rm -f *~; rm -f */*~; rm -f */*/*~
	rm -f */*.aux */*.log */*.out */*.pdf */*.toc
	cd output

distclean: clean
	rm -rf output

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
	cd output; \
	$(LATEXMLC) --dest index.html \
                    --format=html5 --pmml --mathtex \
                    --css=style.css --splitat=section ../source/index.tex

.PHONY: clean distclean html
