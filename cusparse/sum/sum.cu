#include <cstdio>
#include <cassert>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/transform.h>
using namespace std;

void addWithThrust(thrust::host_vector<double>& c,
		   const thrust::host_vector<double>& a,
		   const thrust::host_vector<double>& b){
  thrust::device_vector<double> dev_a = a; // copy Host to Device
  thrust::device_vector<double> dev_b = b; // copy Host to Device
  thrust::device_vector<double> dev_c(c.size());

  cout << "ok" << endl;
  
  /*
  thrust::transform(dev_a.begin(),dev_a.end(), // dev_a for input
		    dev_b.begin(),             // dev_b for input
		    dev_c.begin(),             // dev_c for output
		    [] __device__ (int x, int y) -> int { return x + y; });
  */
  c = dev_c; // copy Device to Host
}

int main(){
  int array_size = 2;
  thrust::host_vector<double> a(array_size);
  thrust::host_vector<double> b(array_size);
  thrust::host_vector<double> c(array_size);

  a.push_back(1);
  a.push_back(2);
  a.push_back(3);
  b.push_back(1);
  b.push_back(2);
  b.push_back(3);
  c.push_back(0);
  c.push_back(0);
  c.push_back(0);
  
  addWithThrust(c, a, b);
  
}

