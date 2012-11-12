.PHONY: clean doc
CC=g++
LD=g++
CFLAGS=-c -Wall -Wextra -I../minini
LDFLAGS =-lprotobuf
SOURCES=Xaccept.c Xbind.c Xclose.c Xconnect.c  XrequestChunk.c  \
		XgetChunkStatus.c  XreadChunk.c  XputChunk.c Xrecv.c \
        Xrecvfrom.c Xsend.c Xsendto.c Xsocket.c   \
		Xsetsockopt.c Xutil.c state.c Xinit.c XupdateAD.c XupdateNameServerDAG.c XgetDAGbyName.c  \
		../minini/minIni.c 
SHARED_OBJECTS=$(SOURCES:.c=.o) xia.pb.o

all: xia.pb.cc  libXsocket.so
	make -C python all

xia.pb.cc: xia.proto
	protoc --cpp_out=.  xia.proto

xia.pb.o: xia.pb.cc xia.pb.h
	$(CC) $(CFLAGS) -fpic xia.pb.cc  -o $@

%.o: %.c X*.h xia.pb.h
	$(CC) $(CFLAGS) -fpic $<  -o $@

libXsocket.so: $(SHARED_OBJECTS) 
	$(LD) -shared -o $@ $(SHARED_OBJECTS) $(LDFLAGS) -lc  -l dl

doc: Xdoc.h $(SOURCES)
	doxygen XsocketsAPI.cfg
	make -C python doc

clean:
	rm -f *.o *.so xia.pb.*
	rm -rf doc
	rm -f ../minini/*.o
	make -C python clean

