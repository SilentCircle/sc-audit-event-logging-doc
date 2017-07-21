.PHONY: all clean

all: audit-logging-doc.pdf

clean:
	rm -f audit-logging-doc.pdf

audit-logging-doc.pdf: audit-logging-doc.md
	sh make-pdf.sh $< $@
