#include <test.hpp>
#include "cudakernel.cuh"
#include <pcl/io/pcd_io.h>
namespace Test
{
    pcl::PointCloud<pcl::PointXYZRGB> testfunction()
    {

        int N = 2000000;
        pcl::PointCloud<pcl::PointXYZRGB> cloud ;
        cloud.width = N;
        cloud.height =1;
        cloud.is_dense=false;
        cloud.points.resize(cloud.width*cloud.height);

        std::vector<Eigen::Vector4f> vertices_val;
        std::vector<Eigen::Vector4f> color_val;
        Eigen::Vector4f vertices;
        Eigen::Vector4f color;
        std::cout <<"number of points: "<< cloud.points.size() <<std::endl;


        for(size_t i=0; i<cloud.points.size(); ++i)
        {

            vertices<<1024*rand()/(RAND_MAX+1.0f), 1024*rand()/(RAND_MAX+1.0f), 1024*rand()/(RAND_MAX+1.0f), 1;
            color<<8.41247e+08*rand()/(RAND_MAX+1.0f), 8.41247e+08*rand()/(RAND_MAX+1.0f), 8.41247e+08*rand()/(RAND_MAX+1.0f), 1;
            vertices_val.push_back(vertices);
            color_val.push_back(color);
        }

        pcl::gpu::DeviceArray<pcl::PointXYZRGB> cloud_device;

        pcl::PointCloud<pcl::PointXYZRGB> x = CudaKernel::dot(vertices_val,color_val,cloud);

        return x;
    } 
}
