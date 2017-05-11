#include <ctime>
#include <cstdlib>
#include <cstdio>

__host__ void  matrixMult(int* const a,int* const b,int* const c,const int n){
	for(int i=0;i<n;i++)
		for(int j=0;j<n;j++)
			for(int k=0;k<n;k++)
				c[i*n+j]+=a[i*n+k]*b[k*n+j];
	return;
}

__host__ void printMatrix(const int* const a,const int n){
	for(int i=0;i<n;i++){
		for(int j=0;j<n;j++)
			printf("%d ",a[i*n+j]);
		printf("\n");
	}
	printf("\n");
}

__host__ void init(int* const a,const int n){
	for(int i=0;i<n;i++)
		for(int j=0;j<n;j++)
			a[i*n+j]=rand()%10;	
	return;
}

__host__ bool validate(const int* const a,const int* const  b,const int n){
	for(int i=0;i<n;i++)
		for(int j=0;j<n;j++)
			if(a[i*n+j]!=b[i*n+j])
				return false;
	return true;
}

 __host__ void  cuAssert(cudaError_t error){
     if(error!=cudaSuccess){
         printf("%s\n",cudaGetErrorString(error));
         exit(0);
     }
 }

__host__ void printTime(char* const s,struct timespec tstart,struct timespec tend){
    printf("%s %.5f seconds\n",s,
           ((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - 
           ((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec));
}  

__global__ void memsetGPUKernel(int* arr,int n){
    int idx=blockDim.x*blockIdx.x+threadIdx.x;
    int idy=blockDim.y*blockIdx.y+threadIdx.y;
    if(idx<n && idy<n)
        arr[idy*n+idx]=0;
    return;
}

__host__ void memsetGPU(int* arr,int n){
    int k=(n+15)/16;
    dim3 grid(k,k);
    dim3 block(16,16);
    memsetGPUKernel<<<grid,block>>>(arr,n);
    cuAssert(cudaGetLastError());
}

__global__ void naive(int* a,int* b,int* c,int n){
	int	idx=blockDim.x*blockIdx.x+threadIdx.x;
	int idy=blockDim.y*blockIdx.y+threadIdx.y;
	if(idx<n && idy<n){
		for(int k=0;k<n;k++)
			c[idx*n+idy]+=a[idx*n+k]*b[k*n+idy];
	}
}

__global__ void common(int* a,int* b,int* c,int n){
	int	idx=blockDim.x*blockIdx.x+threadIdx.x;
	int idy=blockDim.y*blockIdx.y+threadIdx.y;
	if(idx<n && idy<n){
		int sum=0;
		for(int k=0;k<n;k++)
			sum+=a[idy*n+k]*b[k*n+idx];
		c[idy*n+idx]+=sum;
	}
}

__host__ int main(int argc,char* argv[]){
	srand((unsigned)time(NULL));
	struct timespec tstart={0,0}, tend={0,0};
	int block_size;
	const int n=1000;
	printf("Matrix size %d*%d\n",n,n);
	size_t bytes=sizeof(int)*n*n;
	int* a = (int*)malloc(bytes);
	int* b = (int*)malloc(bytes);
	int* c0 = (int*)malloc(bytes);
	int* c1 = (int*)malloc(bytes);
	int* c2 = (int*)malloc(bytes);
	int* d0 = (int*)malloc(bytes);
	int* cpu = (int*)malloc(bytes);
	init(a,n);
	init(b,n);
	memset(c0,0,bytes);
	memset(c1,0,bytes);
	memset(c2,0,bytes);
	memset(d0,0,bytes);
	memset(cpu,0,bytes);

	int* da=NULL;//device a
	int* db=NULL;
	int* dc=NULL;

	cuAssert(cudaMalloc((void**)&da,bytes));
	cuAssert(cudaMalloc((void**)&db,bytes));
	cuAssert(cudaMalloc((void**)&dc,bytes));

	cuAssert(cudaMemcpy(da,a,bytes,cudaMemcpyHostToDevice));
	cuAssert(cudaMemcpy(db,b,bytes,cudaMemcpyHostToDevice));
	memsetGPU(dc,n);
	

//naive - non coalesed
	dim3 grid(n,n,1);
	dim3 block(1,1,1);
	clock_gettime(CLOCK_MONOTONIC, &tstart);
	naive<<<grid,block>>>(da,db,dc,n);
	cuAssert(cudaDeviceSynchronize());
    clock_gettime(CLOCK_MONOTONIC, &tend);
	printTime("GPU 01x01/v1",tstart,tend);
	cuAssert(cudaGetLastError());
	cuAssert(cudaMemcpy(c0,dc,bytes,cudaMemcpyDeviceToHost));
	memsetGPU(dc,n);


//change block size to 32x32 66,6% usage
	block_size=32;
	block.x=block_size;
	block.y=block_size;
	grid.x=(n+block_size-1)/block_size;
	grid.y=(n+block_size-1)/block_size;
	clock_gettime(CLOCK_MONOTONIC, &tstart);
	naive<<<grid,block>>>(da,db,dc,n);
	cuAssert(cudaDeviceSynchronize());
    clock_gettime(CLOCK_MONOTONIC, &tend);
	printTime("GPU 32x32/v1",tstart,tend);
	cuAssert(cudaMemcpy(c1,dc,bytes,cudaMemcpyDeviceToHost));
	memsetGPU(dc,n);


//change block size to 16x16 100% usage
	block_size=16;
	block.x=block_size;
	block.y=block_size;
	grid.x=(n+block_size-1)/block_size;
	grid.y=(n+block_size-1)/block_size;
	clock_gettime(CLOCK_MONOTONIC, &tstart);
	naive<<<grid,block>>>(da,db,dc,n);
	cuAssert(cudaDeviceSynchronize());
    clock_gettime(CLOCK_MONOTONIC, &tend);
	printTime("GPU 16x16/v1",tstart,tend);
	cuAssert(cudaMemcpy(c2,dc,bytes,cudaMemcpyDeviceToHost));
	memsetGPU(dc,n);


//common algoritm block size to 16x16 100% usage
	block_size=16;
	block.x=block_size;
	block.y=block_size;
	grid.x=(n+block_size-1)/block_size;
	grid.y=(n+block_size-1)/block_size;
	clock_gettime(CLOCK_MONOTONIC, &tstart);
	common<<<grid,block>>>(da,db,dc,n);
	cuAssert(cudaDeviceSynchronize());
    clock_gettime(CLOCK_MONOTONIC, &tend);
	printTime("GPU 16x16/v2",tstart,tend);
	cuAssert(cudaMemcpy(d0,dc,bytes,cudaMemcpyDeviceToHost));
	memsetGPU(dc,n);

	cuAssert(cudaFree(da));
	cuAssert(cudaFree(db));
	cuAssert(cudaFree(dc));

	
	clock_gettime(CLOCK_MONOTONIC, &tstart);
	matrixMult(a,b,cpu,n);
    clock_gettime(CLOCK_MONOTONIC, &tend);
	printTime("CPU         ",tstart,tend);
	//printMatrix(cpu,n);
	//printMatrix(c0,n);
	//printMatrix(c1,n);
	printf("validate 01x01/v1 / cpu = %s\n", validate(c0,cpu,n) ? "true" : "false");
	printf("validate 32x32/v1 / cpu = %s\n", validate(c1,cpu,n) ? "true" : "false");
	printf("validate 16x16/v1 / cpu = %s\n", validate(c2,cpu,n) ? "true" : "false");
	printf("validate 16x16/v2 / cpu = %s\n", validate(d0,cpu,n) ? "true" : "false");

	free(a);
	free(b);
	free(c0);
	free(c1);
	free(c2);
	return 0;
}
