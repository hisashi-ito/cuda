#source files
NVCC_src = main.cu PageRankCUSP.cu PageRankCuSparse.cu PageRankLightSpMV.cu PageRankViennaCL.cu

src_dir = ./src
objs_dir = objs
objs += $(patsubst %.cu, $(objs_dir)/%.cu.o, $(NVCC_src))

#GPU architecture
GPU_ARCH = sm_35
GPU_ARCH_FLAGS = -arch $(GPU_ARCH)
ifeq ($(GPU_ARCH), sm_35)
  GPU_ARCH_FLAGS += -DHAVE_SM_35
endif

#use texture memory for CUSP
GPU_ARCH_FLAGS += -DCUSP_USE_TEXTURE_MEMORY -DVIENNACL_WITH_CUDA

#compiling parameters
CXX = nvcc
NVCC = nvcc
NVCCFLAGS = --cudart static -O3 -I. -I $(src_dir) $(GPU_ARCH_FLAGS) -rdc true --ptxas-options=-v -Xcompiler -funroll-loops -Xcompiler -Wall $(MACROS)

EXEC = PageRankCuda

all: dir $(objs)
	$(NVCC) $(NVCCFLAGS) -o $(EXEC) $(objs) -lm -lcusparse
	strip $(EXEC)

dir:
	mkdir -p $(objs_dir)

$(objs_dir)/%.cu.o: $(src_dir)/%.cu
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

clean: 
	rm -rf $(EXEC) $(objs_dir) 

#dependency
SpMV.cu : SpMVCSR.h
