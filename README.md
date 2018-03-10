# Directory structure

    .
    |- src
       |- bibliography.bib          BibTeX formatted bibliography
       |- metadata.yaml             set title, author, etc
       |- metadata-draft.yaml       set line numbers, double spacing, etc for pdf output
       |- sections                  ordered list of document sections
       |- img
       |  |-                        images
       |- md
          |-                        markdown sources for text

Each section has its own file.  There is a sub-directory for images.



# Building

If you have `make`, `pandoc`, and `latex` installed simply run `make`.
Output can be found in `output/`.

If you have only `make` and `pandoc`, running `make odt` or `make docx` will generate a OpenDocument or docx file.
