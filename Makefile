FLATPAK := $(shell which flatpak)
FLATPAK_BUILDER := $(shell which flatpak-builder)

FLATPAK_MANIFEST=com.tutanota.Tutanota.yaml
FLATPAK_APPID=com.tutanota.Tutanota

FLATPAK_BUILD_FLAGS := --verbose --force-clean --install-deps-from=flathub --ccache
FLATPAK_INSTALL_FLAGS := --verbose --force-clean --ccache --user --install
FLATPAK_DEBUG_FLAGS := --verbose --run

all: build

.PHONY: build
build:
	$(FLATPAK_BUILDER) build $(FLATPAK_BUILD_FLAGS) $(FLATPAK_MANIFEST)

.PHONY: debug
debug:
	$(FLATPAK_BUILDER) $(FLATPAK_DEBUG_FLAGS) build $(FLATPAK_MANIFEST) sh

.PHONY: debug-installed
debug-installed:
	$(FLATPAK) run --command=sh --devel $(FLATPAK_APPID)

.PHONY: install
install:
	$(FLATPAK_BUILDER) build $(FLATPAK_INSTALL_FLAGS) $(FLATPAK_MANIFEST)

.PHONY: uninstall
uninstall:
	$(FLATPAK) uninstall $(FLATPAK_APPID)

.PHONY: run
run:
	$(FLATPAK) run $(FLATPAK_APPID)
