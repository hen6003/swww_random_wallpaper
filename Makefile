CURRENTDIR = $(notdir $(CURDIR:/=))

BUILDDIR = build

OUTFILE = $(addprefix $(BUILDDIR)/, $(CURRENTDIR))

SOURCES := $(wildcard *.scm)
OBJECTS := $(addprefix $(BUILDDIR)/, $(SOURCES:%.scm=%.o))

$(OUTFILE): $(OBJECTS)
	csc $+ -o $@

$(BUILDDIR)/%.o: %.scm $(BUILDDIR)
	csc -c $< -o $@

$(BUILDDIR):
	mkdir $@
