#include <cstdlib>
#include <string>
#include <iostream>

__global__ void kernel(int* arr,int n){
	int idx=blockDim.x*blockIdx.x+threadIdx.x;
	if(idx<n){
		arr[idx]=5;
	}
	return;
}

__host__ void  error(std::string message,bool warning=false){
	cudaError_t err=cudaSuccess;
	err=cudaGetLastError();
	if(err!=cudaSuccess){
		std::cerr<<message<<std::endl;
		if(warning)
			return;
		exit(0);
	}

	return;
}

__host__ int main(int argc,char* argv[]){
	int* arr=NULL;
	int* cuArr=NULL;
	const int n=100;
	size_t size=n*sizeof(int);
	
	arr=(int*)malloc(size);
	cudaMalloc((void**)&cuArr,size);

	kernel<<<2,64>>>(cuArr,n);
	cudaMemcpy(arr,cuArr,size,cudaMemcpyDeviceToHost);
	cudaFree(cuArr);
	
	for(int i=0;i<n;i++){
		std::cout<<arr[i]<<" ";
	}
	std::cout<<std::endl;
	free(arr);

	return 0;
}
