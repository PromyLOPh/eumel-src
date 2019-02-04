all: _build/index.html

_build:
	mkdir -p $@
	find app devel doc/ lang system -mindepth 4 -type f | grep '/src/' | parallel 'tools/highlight.py {}'

_build/packages.rst: | _build
	tools/makeindex.py > $@

_build/index.html: README.rst _build/packages.rst
	rst2html5.py --cloak-email-addresses --math-output=mathjax \
		--syntax-highlight=short --link-stylesheet \
		--stylesheet=../../style.min.css \
		--template=./template.txt \
		--footnote-references=superscript < README.rst > $@

.PHONY: clean _build/packages.rst

clean:
	$(RM) -r _build

