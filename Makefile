NAME      := $(shell grep ^id mod.info | cut -f2 -d=)
BUNDLE    := dist
BUNDLEDIR := $(BUNDLE)/$(NAME)

all: bundle

build:
	transcode $(NAME)

bundle: build
	rm -rf $(BUNDLE) && mkdir -p $(BUNDLEDIR)                    && \
	cp -r mod.info media *.png LICENSE README.md $(BUNDLEDIR)    && \
	find $(BUNDLE) -type f -iname '*.utf8.txt' -exec rm -f {} \; && \
	cd $(BUNDLE) && zip -r $(NAME).zip $(NAME)

bundlesteam: bundle

clean:
	rm -rf dist

.PHONY: build dist
