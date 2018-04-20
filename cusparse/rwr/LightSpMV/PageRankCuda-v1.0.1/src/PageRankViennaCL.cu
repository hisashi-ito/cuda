/*
 * PageRankViennaCL.cu
 *
 *  Created on: Jun 30, 2015
 *      Author: yongchao
 */

/*ViennaCL*/
#include "PageRank.h"
struct viennaclOptions {
	viennaclOptions() {
		/*default settings*/
		_gpuId = 0;
		_nrepeats = 10;
		_sparseMatFormat = CSR_FORMAT;
		_doublePrecision = false;
	}

	/*variables*/
	int _gpuId;
	int _nrepeats;
	int _sparseMatFormat; /*sparse matrix format*/
	string _graphFileName; /*adjacency matrix of the graph stored in sparse matrix*/
	bool _doublePrecision; /*use single precision*/
	vector<int> _gpus;

	void printUsage() {
		cerr << "PageRankCuda viennacl [options]" << endl << "Options: " << endl
				<< "\t-i <str> (sparse matrix file name)" << endl
				<< "\t-d <int> (use double-precision floating point, default="
				<< _doublePrecision << ")" << endl
				<< "\t-r <int> (number of repeated runs, default=" << _nrepeats
				<< ")" << endl << "\t-g <int> (GPU index to use, default="
				<< _gpuId << ")" << endl << endl;
	}
	bool parseArgs(int argc, char* argv[]) {
		int c;

		/*GPU information*/
		int count;
		cudaDeviceProp prop;
		cudaGetDeviceCount(&count);
		CudaCheckError();

#if defined(HAVE_SM_35)
		cerr << "Require GPUs with compute capability >= 3.5" << endl;
#else
		cerr << "Require GPUs with compute capability >= 3.0" << endl;
#endif
		/*check the compute capability of GPUs*/
		for (int i = 0; i < count; ++i) {
			cudaGetDeviceProperties(&prop, i);
#if defined(HAVE_SM_35)
			if ((prop.major * 10 + prop.minor) >= 35) {
#else
			if ((prop.major * 10 + prop.minor) >= 30) {
#endif
				cerr << "GPU " << _gpus.size() << ": " << prop.name
						<< " (capability " << prop.major << "." << prop.minor
						<< ")" << endl;
				/*save the GPU*/
				_gpus.push_back(i);
			}
		}
		if (_gpus.size() == 0) {
			cerr << "No qualified CUDA-enabled GPU is available" << endl;
			return false;
		}
		cerr << "Number of qualified GPUs: " << _gpus.size() << endl;

		/*parse parameters*/
		while ((c = getopt(argc, argv, "i:d:r:g:\n")) != -1) {
			switch (c) {
			case 'i':
				_graphFileName = optarg;
				break;
			case 'g':
				_gpuId = atoi(optarg);
				break;
			case 'd':
				_doublePrecision = atoi(optarg) == 0 ? false : true;
				break;
			case 'r':
				_nrepeats = atoi(optarg);
				if (_nrepeats < 1) {
					_nrepeats = 1;
				}
				break;
			default:
				cerr << "Unknown command: " << optarg << endl;
				return false;
			}
		}
		/*check the file name*/
		if (_graphFileName.length() == 0) {
			cerr << "Graph must be given" << endl;
			return false;
		}

		/*check GPU ID*/
		if (_gpuId >= (int) _gpus.size()) {
			_gpuId = _gpus.size() - 1;
		}
		if (_gpuId < 0) {
			_gpuId = 0;
		}
		return true;
	}
};

int main_viennacl_pagerank(int argc, char* argv[]) {
	viennaclOptions options;

	/*parse parameters*/
	if (options.parseArgs(argc, argv) == false) {
		options.printUsage();
		return -1;
	}

	/*set the GPU device*/
	cudaSetDevice(options._gpus[options._gpuId]);
	CudaCheckError();

	/*perform SpMV*/
	bool ret = false;
	switch (options._sparseMatFormat) {
	case CSR_FORMAT:
		if (options._doublePrecision) {
			/*using double precision*/
			ret = pageRankViennaCL<unsigned int, double>(
					options._graphFileName.c_str(), options._nrepeats);

		} else {
			/*using single precision*/
			ret = pageRankViennaCL<unsigned int, float>(
					options._graphFileName.c_str(), options._nrepeats);
		}
		break;
	}
	return ret ? 0 : -1;
}

