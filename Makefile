DOCKER = docker run --rm -v "$$PWD":/work -u $$(id -u):$$(id -g) -e HOME=/tmp -w /work ghcr.io/rendercv/rendercv
DOCKER_MAIN = $(DOCKER) render Anton_Lu_CV.yaml
DOCKER_INDUSTRY = $(DOCKER) render Anton_Lu_CV_industry.yaml --pdf-path rendercv_output/Anton_Lu_CV_industry.pdf

all:
	$(DOCKER_MAIN)

pdf:
	$(DOCKER_MAIN) --dont-generate-html --dont-generate-markdown --dont-generate-png

png:
	$(DOCKER_MAIN) --dont-generate-pdf --dont-generate-html --dont-generate-markdown

html:
	$(DOCKER_MAIN) --dont-generate-pdf --dont-generate-png --dont-generate-markdown

markdown:
	$(DOCKER_MAIN) --dont-generate-pdf --dont-generate-html --dont-generate-png

industry:
	$(DOCKER_INDUSTRY) --dont-generate-html --dont-generate-markdown --dont-generate-png

industry-all:
	$(DOCKER_INDUSTRY)

clean:
	rm -rf rendercv_output

.PHONY: all pdf png html markdown industry industry-all clean
