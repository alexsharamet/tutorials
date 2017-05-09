#include <cstdio>
__global__ void init5(int* arr, int n){
	int idx=blockDim.x*blockIdx.x+threadIdx.x;
	if(idx<n*n)
		arr[idx]=5;
}

__global__ void init7(int* arr,int n){
	int idx=blockDim.x*blockIdx.x+threadIdx.x;
	int idy=blockDim.y*blockIdx.y+threadIdx.y;

	arr[idy*n+idx]=7;
}

__host__ void printMtrx(int* const mtrx,const int n){
	for(int i=0;i<n;i++){
		for(int j=0;j<n;j++)
			printf("%d ",mtrx[i*n+j]);
		printf("\n");
	}
	printf("\n");
}

__host__ int main(int argc,char* argv[]){
	const int n = 5;
	size_t bytes=sizeof(int)*n*n;

	int* cuMtrx=NULL;
	cudaMalloc((void**)&cuMtrx,bytes);

	int* mt1=(int*)malloc(bytes);
	memset(mt1,0,bytes);

	cudaMemcpy(cuMtrx,mt1,bytes,cudaMemcpyHostToDevice);
	init5<<<n*n,1>>>(cuMtrx,n);
	cudaMemcpy(mt1,cuMtrx,bytes,cudaMemcpyDeviceToHost);
	printMtrx(mt1,n);

	dim3 grid(n,n,1);
	init7<<<grid,1>>>(cuMtrx,n);
	cudaMemcpy(mt1,cuMtrx,bytes,cudaMemcpyDeviceToHost);
	printMtrx(mt1,n);

	cudaFree(cuMtrx);

	return 0;
}
