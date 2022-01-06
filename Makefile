MODID          := $(shell grep ^id mod.info | cut -f2 -d=)
MODNAME        := $(shell grep ^name mod.info | cut -f2 -d=)
VERSION        := $(shell git tag -l | tail -n 1)
BUNDLE         := dist
BUNDLEDIR      := $(BUNDLE)/$(MODID)
STEAMBUNDLE    := ~/Zomboid/Workshop/$(MODID)
STEAMBUNDLEDIR := $(STEAMBUNDLE)/Contents/mods

all: steambundle

build:
	transcode $(MODID) && \
	rm -rf $(BUNDLE) && mkdir -p $(BUNDLEDIR)                    &&  \
	cp -r mod.info media *.png LICENSE README.md $(BUNDLEDIR)    &&  \
	find $(BUNDLE) -type f -iname '*.utf8.txt' -exec rm -f {} \; &&  \
	sed -i                                                           \
		-e "s/^name=$(MODNAME).*$$/name=$(MODNAME) (v$(VERSION))/" \
		$(BUNDLEDIR)/mod.info

bundle: build
	cd $(BUNDLE) && zip -r $(MODID)-$(VERSION).zip $(MODID)

steambundle: bundle
	rm -rf $(STEAMBUNDLE) && mkdir -p $(STEAMBUNDLEDIR) && \
	cp workshop.txt preview.png $(STEAMBUNDLE)          && \
	cp -r $(BUNDLEDIR) $(STEAMBUNDLEDIR)                && \
	sed -i                                                 \
		-e "s/^version=.*$$/version=$(VERSION)/"           \
		-e "s/^description=Latest version:.*$$/description=Latest version: $(VERSION)/" \
		$(STEAMBUNDLE)/workshop.txt

clean:
	rm -rf $(BUNDLE) $(STEAMBUNDLE)

.PHONY: build dist
