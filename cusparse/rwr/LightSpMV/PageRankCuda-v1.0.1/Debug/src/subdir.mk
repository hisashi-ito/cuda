################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../src/PageRankCUSP.cu \
../src/PageRankCuSparse.cu \
../src/PageRankLightSpMV.cu \
../src/PageRankViennaCL.cu \
../src/main.cu 

OBJS += \
./src/PageRankCUSP.o \
./src/PageRankCuSparse.o \
./src/PageRankLightSpMV.o \
./src/PageRankViennaCL.o \
./src/main.o 

CU_DEPS += \
./src/PageRankCUSP.d \
./src/PageRankCuSparse.d \
./src/PageRankLightSpMV.d \
./src/PageRankViennaCL.d \
./src/main.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-7.0/bin/nvcc -I"/opt/yongchao/workspace/PageRankCuda-v1.0.1" -I"/opt/yongchao/workspace/PageRankCuda-v1.0.1/cusp" -G -g -O0 -gencode arch=compute_35,code=sm_35  -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-7.0/bin/nvcc -I"/opt/yongchao/workspace/PageRankCuda-v1.0.1" -I"/opt/yongchao/workspace/PageRankCuda-v1.0.1/cusp" -G -g -O0 --compile --relocatable-device-code=true -gencode arch=compute_35,code=sm_35  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


