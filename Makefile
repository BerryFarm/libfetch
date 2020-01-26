# libfetch
LIBFETCH_OBJS = src/common.o src/fetch.o src/file.o
LIBFETCH_OBJS += src/ftp.o src/http.o
LIBFETCH_CPPFLAGS = -DFTP_COMBINE_CWDS -DINET6 -DWITH_SSL
ifdef HAVE_VISIBILITY
LIBFETCH_CFLAGS= -fvisibility=hidden
endif
LIBFETCH_INCS = src/common.h
LIBFETCH_GEN = src/ftperr.h src/httperr.h

.PHONY: all
all: $(LIBFETCH_OBJS)

src/ftperr.h: src/ftp.errors
	@printf " [GEN]\t\t$@\n"
	${SILENT}./src/errlist.sh ftp_errlist FTP $< > $@

src/httperr.h: src/http.errors
	@printf " [GEN]\t\t$@\n"
	@./src/errlist.sh http_errlist HTTP $< > $@

$(LIBFETCH_OBJS): %.o: %.c $(LIBFETCH_INCS) $(LIBFETCH_GEN)
	@printf " [CC]\t\t$@\n"
	${SILENT}$(CC) $(CPPFLAGS) $(LIBFETCH_CPPFLAGS) $(CFLAGS) \
		$(LIBFETCH_CFLAGS) -c $< -o $@

.PHONY: install
install: all
	install -d $(DESTDIR)$(LIBDIR)

.PHONY: clean
clean:
	-rm -f $(LIBFETCH_OBJS)
	-rm -f $(LIBFETCH_GEN)
