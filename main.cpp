#include <test.hpp>
#include <iostream>

// Main
int main(int argc, char ** argv)
{
    pcl::PointCloud<pcl::PointXYZRGB> x = Test::testfunction();
    pcl::io::savePCDFileASCII ("test_pcd.pcd", x);

    std::cerr << ">> Testfunction returned: " << x.size() << std::endl;

	return 0;
}
