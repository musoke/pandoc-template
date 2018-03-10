MAIN = output/main

OUT_DIR := output
SRC_DIR := src
MD_DIR := src/md

SECTIONS := $(shell cat src/sections | tr '\n\r' ' ' | tr '\n' ' ' )
REF = $(addprefix $(MD_DIR)/, references.md)
BIB = $(SRC_DIR)/bibliography.bib
META = $(addprefix $(SRC_DIR)/, metadata.yaml)

ALL_MD = $(addprefix $(MD_DIR)/, $(addsuffix .md, $(SECTIONS)))
ALL_DOCX = $(addprefix $(OUT_DIR)/, $(addsuffix .docx, $(SECTIONS)))
ALL_ODT = $(addprefix $(OUT_DIR)/, $(addsuffix .odt, $(SECTIONS)))
ALL_TEX = $(addprefix $(OUT_DIR)/, $(addsuffix .tex, $(SECTIONS)))
ALL_PDF = $(addprefix $(OUT_DIR)/, $(addsuffix .pdf, $(SECTIONS)))

# All the source files other the bibliography
# The bibliography is specified in another argument
ALL_PANDOC_SRC_ARGS = \
	$(ALL_MD) \
	$(META)

ALL_SOURCE = \
	$(ALL_PANDOC_SRC_ARGS) \
	$(BIB)

.PHONY: pdf
pdf: $(MAIN).pdf

.PHONY: draft-pdf
draft-pdf: $(MAIN)-draft.pdf

# Compile the whole document
$(MAIN).pdf: $(ALL_SOURCE)
	pandoc $(ALL_PANDOC_SRC_ARGS) --bibliography=$(BIB) -o $@
$(MAIN).docx: $(ALL_SOURCE)
	pandoc $(ALL_PANDOC_SRC_ARGS) --bibliography=$(BIB) -o $@
$(MAIN).odt: $(ALL_SOURCE)
	pandoc $(ALL_PANDOC_SRC_ARGS) --bibliography=$(BIB) -o $@
$(MAIN).tex: $(ALL_SOURCE)
	pandoc $(ALL_PANDOC_SRC_ARGS) --bibliography=$(BIB) -o $@
$(MAIN).zip:
	git archive -o $@ HEAD
$(MAIN)-draft.pdf: \
	$(ALL_SOURCE) \
	metadata-draft.yaml \

	pandoc $(ALL_PANDOC_SRC_ARGS) metadata-draft.yaml --filter pandoc-citeproc -o $@ --bibliography=$(BIB)

.PHONY: all
all: all-formats sections $(MAIN).zip

.PHONY: all-formats
all-formats: \
	$(MAIN).pdf \
	$(MAIN).docx \
	$(MAIN).odt \
	$(MAIN).tex \

.PHONY: sections
sections: $(ALL_ODT) $(ALL_DOCX) $(ALL_TEX) $(ALL_PDF)

# Compile only a section
$(ALL_DOCX): $(OUT_DIR)/%.docx: $(MD_DIR)/%.md $(REF) $(META) $(BIB)
	pandoc $< $(REF) $(META) --bibliography=$(BIB) -o $@
$(ALL_ODT): $(OUT_DIR)/%.odt: $(MD_DIR)/%.md $(REF) $(META) $(BIB)
	pandoc $< $(REF) $(META) --bibliography=$(BIB) -o $@
$(ALL_TEX): $(OUT_DIR)/%.tex: $(MD_DIR)/%.md $(REF) $(META) $(BIB)
	pandoc $< $(REF) $(META) --bibliography=$(BIB) -o $@
$(ALL_PDF): $(OUT_DIR)/%.pdf: $(MD_DIR)/%.md $(REF) $(META) $(BIB)
	pandoc $< $(REF) $(META) --bibliography=$(BIB) -o $@

.PHONY: clean
clean:
	@ rm $(OUT_DIR)/*
