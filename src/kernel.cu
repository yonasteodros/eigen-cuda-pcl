#include <cudakernel.cuh>
#include <iostream>
#include <stdio.h>
#include <eigen3/Eigen/Core>

static void HandleError( cudaError_t err, const char *file, int line )
{
	// CUDA error handeling from the "CUDA by example" book
	if (err != cudaSuccess)
    {
		printf( "%s in %s at line %d\n", cudaGetErrorString( err ), file, line );
		exit( EXIT_FAILURE );
	}
}

#define HANDLE_ERROR( err ) (HandleError( err, __FILE__, __LINE__ ))

// CUDA Version
namespace CudaKernel
{
    __global__ void cu_dot(Eigen::Vector4f *v1, Eigen::Vector4f *c1, pcl::gpu::PtrSz<pcl::PointXYZRGB> output, size_t N)
    {
        int idx = blockIdx.x * blockDim.x + threadIdx.x;


        if(idx < N)
        {
            output[idx].x = v1[idx].x();
            output[idx].y = v1[idx].y();
            output[idx].z = v1[idx].z();


            unsigned char r = int(c1[idx].x()) >> 16 & 0xFF; /* gets 2nd MSB 0x06 */
            unsigned char g = int(c1[idx].y()) >> 8 & 0xFF; /* gets the 2nd LSB 0xd3 */
            unsigned char b = int(c1[idx].z()) & 0xFF; /* gets the LSB 0xb0 */
            uint32_t rgb = ((uint32_t)r << 16 | (uint32_t)g << 8 | (uint32_t)b);

            output[idx].rgb=*reinterpret_cast<float*>(&rgb);

        }

        return;
    }

    // The wrapper for the calling of the actual kernel
    pcl::PointCloud<pcl::PointXYZRGB> dot(const std::vector<Eigen::Vector4f> & v1, const std::vector<Eigen::Vector4f> & c1, const pcl::PointCloud<pcl::PointXYZRGB> & output)
    {
        int n = v1.size();
        double *ret = new double[n];
        pcl::PointCloud<pcl::PointXYZRGB> cloud;
        cloud.width  = n;
        cloud.height = 1;
        cloud.is_dense=false;
        cloud.points.resize (cloud.width * cloud.height);

        // Allocate device arrays
        Eigen::Vector4f *dev_v1;
        Eigen::Vector4f *dev_c1;
        HANDLE_ERROR(cudaMalloc((void **)&dev_v1, sizeof(Eigen::Vector4f)*n));
        HANDLE_ERROR(cudaMalloc((void **)&dev_c1, sizeof(Eigen::Vector4f)*n));

        pcl::gpu::DeviceArray<pcl::PointXYZRGB> dev_pcl;
        dev_pcl.create(n);
        //pcl :: gpu :: DeviceArray <pcl :: PointXYZ> DevicePointArray (n);//allocation the new GPU memory!

        HANDLE_ERROR(cudaMalloc((void **)&dev_pcl, sizeof(pcl::PointXYZRGB)*n));

        // Copy to device
        HANDLE_ERROR(cudaMemcpy(dev_v1, v1.data(), sizeof(Eigen::Vector4f)*n, cudaMemcpyHostToDevice));
        HANDLE_ERROR(cudaMemcpy(dev_c1, c1.data(), sizeof(Eigen::Vector4f)*n, cudaMemcpyHostToDevice));

        cu_dot<<<(n+1023)/1024, 1024>>>(dev_v1, dev_c1, dev_pcl, n);

        dev_pcl.download(cloud.points);

        return cloud;
    }
}

