COMMAND_NAME = sorter
BINARY_PATH = ./.build/release/$(COMMAND_NAME)
VERSION = 0.0.1

.PHONY: release
release:
	mkdir -p releases
	swift build -c release
	cp $(BINARY_PATH) sorter
	tar acvf releases/Sorter_$(VERSION).tar.gz sorter
	cp sorter releases/sorter
	rm sorter

.PHONY: sorter
sorter:
	mint run sorter -p .
