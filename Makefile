
# CROSS_COMPILE=""
#CROSS_COMPILE=/home/mattlin/Desktop/works/acs/Q654/crossgcc/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
CC=$(CROSS_COMPILE)gcc
CXX=$(CROSS_COMPILE)g++

DEBUG=0

OPENCV_INCLUDE=opencv/include
OPENCV_LIB=opencv/lib

#VIVANTE_SDK_DIR=/home/mattlin/VeriSilicon/VivanteIDE5.8.2/cmdtools/vsimulator
#VIVANTE_SDK_DIR=./vip9000sdk-6.4.15.9/6.4.15.9

INCLUDES=-I. -I$(VIVANTE_SDK_DIR)/include/ \
 -I$(VIVANTE_SDK_DIR)/include/CL \
 -I$(VIVANTE_SDK_DIR)/include/VX \
 -I$(VIVANTE_SDK_DIR)/include/ovxlib \
 -I$(VIVANTE_SDK_DIR)/include/ovxlib/utils \
 -I$(VIVANTE_SDK_DIR)/include/ovxlib/ops \
 -I$(VIVANTE_SDK_DIR)/include/jpeg
#   $(shell pkg-config opencv4 --cflags) \

INCLUDES += -I$(OPENCV_INCLUDE)

CFLAGS=-Wall -std=c++0x $(INCLUDES) -D__linux__ -DLINUX -fpermissive -fopenmp
CFLAGS+=-O3
LFLAGS+=-O3 -Wl,-rpath-link=$(VIVANTE_SDK_DIR)/drivers
LFLAGS+=-Wl,-rpath-link=$(OPENCV_LIB)

LIBS+= -L$(VIVANTE_SDK_DIR)/drivers \
 -lOpenVX -lOpenVXU -lovxlib -ljpeg -lm -lstdc++

LIBS += -lopencv_core -lopencv_imgproc -lopencv_videoio -lopencv_dnn -lopencv_objdetect -lopencv_imgcodecs -lopencv_highgui
LIBS += -L$(OPENCV_LIB)

SRCS=${wildcard *.c}
SRCS+=${wildcard *.cpp}

BIN=main

OBJS=$(addsuffix .o, $(basename $(SRCS)))

.SUFFIXES: .cpp .c

.cpp.o:
	$(CC) $(CFLAGS) -c $<

.cpp:
	$(CXX) $(CFLAGS) $< -o $@ -lm

.c.o:
	$(CC) $(CFLAGS) -c $<

.c:
	$(CC) $(CFLAGS) $< -o $@ -lm

all: $(BIN)

$(BIN): $(OBJS)
	$(CXX) $(CFLAGS) $(LFLAGS) $(EXTRALFLAGS) $(OBJS) $(LIBS) -o $@

clean:
	rm -rf *.o
	rm -rf $(BIN)
	rm -rf *~
