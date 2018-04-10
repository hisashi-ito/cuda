#ifndef _SUM_
#define _SUM_

#include <cstdio>
#include <cassert>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/transform.h>
using namespace std;

class Sum{
 public:
  Sum(void);
  ~Sum(void);
  void addWithThrust(thrust::host_vector<double>& c,
		     const thrust::host_vector<double>& a,
		     const thrust::host_vector<double>& b);
};
#endif /*_SUM_*/
