#pragma once
#ifndef TEST_H
#define TEST_H
#include <pcl/point_types.h>
#include <pcl/point_cloud.h>
#include <pcl/io/pcd_io.h>
//PCL refere https://www.cnblogs.com/zipeilu/p/6117304.html
namespace Test
{
    pcl::PointCloud<pcl::PointXYZRGB> testfunction();
}

#endif
