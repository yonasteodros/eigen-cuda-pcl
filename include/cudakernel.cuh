#ifndef CUDAKERNEL_CUH
#define CUDAKERNEL_CUH

#include <cuda_runtime_api.h>
#include <iostream>
#include <stdio.h>
#include <vector>
#include <eigen3/Eigen/Core>
#include <pcl/point_types.h>
#include <pcl/point_cloud.h>
#include <pcl/gpu/containers/device_array.h>


namespace CudaKernel
{
    pcl::PointCloud<pcl::PointXYZRGB> dot(const std::vector<Eigen::Vector4f> &v1, const std::vector<Eigen::Vector4f> &c1,const pcl::PointCloud<pcl::PointXYZRGB> &output);
}

#endif // CUDAKERNEL_CUH
