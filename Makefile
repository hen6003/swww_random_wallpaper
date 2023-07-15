CURRENTDIR = $(notdir $(CURDIR:/=))

BUILDDIR = build

SOURCES := $(wildcard *.scm)
OBJECTS := $(addprefix $(BUILDDIR)/, $(SOURCES:%.scm=%.o))

$(CURRENTDIR): $(OBJECTS)
	csc $+ -o $@

$(BUILDDIR)/%.o: %.scm $(BUILDDIR)
	csc -c $< -o $@

$(BUILDDIR):
	mkdir $@
