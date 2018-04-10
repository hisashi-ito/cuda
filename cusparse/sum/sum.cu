#include "sum.h"

// コンストラクタ
Sum::Sum(void){}
// デストラクタ
Sum::~Sum(void){}

void Sum::addWithThrust(thrust::host_vector<double>& c,
		   const thrust::host_vector<double>& a,
		   const thrust::host_vector<double>& b){
  thrust::device_vector<double> dev_a = a; // copy Host to Device
  thrust::device_vector<double> dev_b = b; // copy Host to Device
  thrust::device_vector<double> dev_c(c.size());
} // Sum 

#ifdef _DEBUG_
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
  Sum *s = new Sum();
  s->addWithThrust(c, a, b);
}
#endif /*_DEBUG_*/
