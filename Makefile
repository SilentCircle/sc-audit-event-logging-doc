.PHONY: all clean output

all: audit-logging-doc.pdf

clean:
	rm -f audit-logging-doc.pdf

audit-logging-doc.pdf: audit-logging-doc.md
	sh make-pdf.sh $< $@

output: all
	cp -a audit-logging-doc.md audit-logging-doc-$$(date -u +%Y%m%d).md
	cp -a audit-logging-doc.pdf audit-logging-doc-$$(date -u +%Y%m%d).pdf
	sh version-doc.sh audit-logging-doc-$$(date -u +%Y%m%d).md
