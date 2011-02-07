BINDIR = bin
CC = gcc
CFLAGS = -fPIC -g3 -Iinclude -Wall
INCDIR = include
LIBDIR = lib
LIBS = `pkg-config --libs allegro-5.1 allegro_font-5.1 allegro_image-5.1 allegro_primitives-5.1 allegro_ttf-5.1`
MKDIR = mkdir -p
OBJDIR = obj
REMOVE = rm -fR
SONAME = libalgui.so
SRCDIR = src
SYMLINK = ln -fs
VERSION = 1

LIBRARY = ${LIBDIR}/${SONAME}.${VERSION}
LIBOBJS = ${OBJDIR}/algui_list.o \
          ${OBJDIR}/algui_rect.o \
          ${OBJDIR}/algui_tree.o \
          ${OBJDIR}/algui_widget.o
PROGRAM = ${BINDIR}/example

.PHONY: all clean help library program run

all: ${BINDIR} ${LIBDIR} ${OBJDIR} ${LIBRARY} ${PROGRAM} 

clean:
	${REMOVE} ${BINDIR} ${LIBDIR} ${OBJDIR}

help:
	@echo 'Available targets:' && \
	echo '    all: Build library and example program.' && \
	echo '    clean: Remove generated files and directories.' && \
	echo '    help: Show this message.' && \
	echo '    library: Build the shared object library.' && \
	echo '    program: Build library and example program.' && \
	echo '    run: Build library and example and run example.'

library: ${LIBDIR} ${OBJDIR} ${LIBRARY}

program: ${BINDIR} library ${PROGRAM}

run: all
	LD_LIBRARY_PATH=${LIBDIR} ${PROGRAM}

${LIBRARY}: ${LIBOBJS}
	${CC} -shared -Wl,-soname,${SONAME} -o $@ $? ${LIBS}
	${SYMLINK} ${SONAME}.${VERSION} ${LIBDIR}/${SONAME}

${BINDIR}:
	${MKDIR} $@

${LIBDIR}:
	${MKDIR} $@

${OBJDIR}:
	${MKDIR} $@

${PROGRAM}: ${OBJDIR}/_main.o $(LIBRARY)
	${CC} -o $@ $< ${LIBS} -L${LIBDIR} -lalgui

${OBJDIR}/_main.o: _main.c
	${CC} ${CFLAGS} `pkg-config --cflags allegro-5.1` -c -o $@ $<

${OBJDIR}/algui_list.o: ${SRCDIR}/algui_list.c
	${CC} ${CFLAGS} `pkg-config --cflags allegro-5.1` -c -o $@ $<

${OBJDIR}/algui_rect.o: ${SRCDIR}/algui_rect.c
	${CC} ${CFLAGS} `pkg-config --cflags allegro-5.1` -c -o $@ $<

${OBJDIR}/algui_tree.o: ${SRCDIR}/algui_tree.c
	${CC} ${CFLAGS} `pkg-config --cflags allegro-5.1` -c -o $@ $<

${OBJDIR}/algui_widget.o: ${SRCDIR}/algui_widget.c
	${CC} ${CFLAGS} `pkg-config --cflags allegro-5.1` -c -o $@ $<

