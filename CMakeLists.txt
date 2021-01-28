######### CMake Version #####################
cmake_minimum_required(VERSION 2.8.11)

project(eigencuda)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}")
set(CMAKE_BUILD_TYPE Debug)

SET( EXECUTABLE_NAME run )

find_package(CUDA REQUIRED)
message("-- CUDA version: ${CUDA_VERSION}")
set(CUDA_ARCH_BIN "35 50 52 61" CACHE STRING "Specify 'real' GPU arch     to build binaries for, BIN(PTX) format is supported. Example: 1.3 2.1(1.3) o    r 13 21(13)")
set(CUDA_ARCH_PTX "" CACHE STRING "Specify 'virtual' PTX arch to build PTX intermediate code for. Example: 1.0 1.2 or 10 12")

SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR})
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}  "-Xcompiler;-fPIC;")
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} "--ftz=true;--prec-div=false;--prec-sqrt=false")
CUDA_COMPILE(cuda_objs ${cuda})

find_path(OPENNI2_INCLUDE_DIR OpenNI.h
          HINTS ${NESTK_ROOT_DIRS_HINTS} ${PC_OPENNI_INCLUDEDIR} ${PC_OPENNI_INCLUDE_DIRS} /media/user/Data/DeepLearning/Fusion/deps/OpenNI2/Include /media/user/Data/DeepLearning/Fusion/deps/OpenNI2/Include/ni2
          PATHS "$ENV{PROGRAMFILES}/OpenNI2/Include" "$ENV{PROGRAMW6432}/OpenNI2/Include"
          PATH_SUFFIXES openni ni)
#add a hint so that it can find it without the pkg-config
find_library(OPENNI2_LIBRARY
             NAMES OpenNI2
             HINTS ${NESTK_ROOT_DIRS_HINTS} ${PC_OPENNI_LIBDIR} ${PC_OPENNI_LIBRARY_DIRS} /media/user/Data/DeepLearning/Fusion/deps/OpenNI2/Bin/x64-Release
             PATHS "$ENV{PROGRAMFILES}/OpenNI2/Redist" "$ENV{PROGRAMW6432}/OpenNI2/Redist" "$ENV{PROGRAMW6432}/OpenNI2"
             PATH_SUFFIXES lib lib64
)

set(PCL_DIR "/media/user/Data/programs/installed/share/pcl-1.9/")
find_package(PCL 1.9 REQUIRED COMPONENTS common io octree filters gpu_containers)
add_definitions(${PCL_DEFINITIONS})


set(SOURCE_FILES
    src/test.cpp
    src/kernel.cu
    src/kernel.cpp
)

set(HEADER_FILES
    include/test.hpp
    include/kernel.hpp
    include/cudakernel.cuh

)

include_directories( ${EXECUTABLE_NAME} PUBLIC ${PROJECT_SOURCE_DIR}/include ${EIGEN_INCLUDE_DIRS} ${PCL_INCLUDE_DIRS} ${OPENNI2_INCLUDE_DIR} )
cuda_add_executable( ${EXECUTABLE_NAME} main.cpp ${SOURCE_FILES} )
target_include_directories( ${EXECUTABLE_NAME} PUBLIC ${PROJECT_SOURCE_DIR}/include ${EIGEN_INCLUDE_DIRS} ${PCL_INCLUDE_DIRS})
target_link_libraries( ${EXECUTABLE_NAME} ${CUDA_LIBRARIES} ${Eigen_LIBRARIES} ${OPENNI2_LIBRARY} ${PCL_LIBRARIES} ${PCL_VISUALIZATION_LIBRARIES})

