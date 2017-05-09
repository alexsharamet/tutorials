#include <cstdio>

__global__ void init7(int* arr,size_t pitch,int n){
	int idx=blockDim.x*blockIdx.x+threadIdx.x;
	int idy=blockDim.y*blockIdx.y+threadIdx.y;
	if(idx <n && idy<n){
		int* row=(int*)( (char*)arr +idy*pitch);
		row[idx]=7;
	}
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
	size_t pitch;
	size_t size=n*sizeof(n);
	int* devPtr=NULL;
	cudaMallocPitch((void**)&devPtr,&pitch,size,n);
	
	int* mt1=(int*)malloc(n*size);
	memset(mt1,0,n*size);
	
	dim3 grid(n,n,1);
	init7<<<grid,1>>>(devPtr,pitch,n);
	cudaMemcpy2D(mt1,size,devPtr,pitch,size,n,cudaMemcpyDeviceToHost);
	printMtrx(mt1,n);
	cudaFree(devPtr);
	free(mt1);
	return 0;
}
