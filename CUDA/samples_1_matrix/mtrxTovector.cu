#include <cstdio>
#define BLOCK_SIZE 256

__global__ void mtrxToVec(int* mtrx,int* vec, int* ans,int n){
	int idx=blockDim.x*blockIdx.x+threadIdx.x;
	while(idx<n){
		int sum=0;
		for(int i=0;i<n;i++)
			sum+=mtrx[n*i+idx]*vec[idx];
		ans[idx]=sum;
		idx+=gridDim.x*blockDim.x;
	}
	return;
}


__global__ void mtrxToVecY(int* mtrx,int* vec, int* ans,int n){
	int idy=blockDim.y*blockIdx.y+threadIdx.y;
	while(idy<n){
		int sum=0;
		for(int i=0;i<n;i++)
			sum+=mtrx[n*i+idy]*vec[idy];
		ans[idy]=sum;
		idy+=gridDim.y*blockDim.y;
	}
	return;
}

__global__ void transposeMtrxToVec(int* mtrx,int* vec, int* ans,int n){
	int idx=blockDim.x*blockIdx.x+threadIdx.x;
	while(idx<n){
		int sum=0;
		for(int i=0;i<n;i++)
			sum+=mtrx[n+idx*i]*vec[idx];
		ans[idx]=sum;
		idx+=gridDim.x*blockDim.x;
	}
	return;
}

__host__ void  cuAssert(cudaError_t error){
	if(error!=cudaSuccess){
		printf("%s\n",cudaGetErrorString(error));
		exit(0);
	}
}

__host__ void print(int* ans,int n){
	for(int i=0;i<n;i++)
		printf("%5d ",ans[i]);
	printf("\n");
	return;
}

__host__ int main(int argc,char* argv[]){
	cudaEvent_t start,stop;
	cuAssert(cudaEventCreate(&start));
	cuAssert(cudaEventCreate(&stop));
	float time;

	const int n=10000;
	size_t size=sizeof(int)*n;
	int* vec=(int*)malloc(size);
	int* ans=(int*)malloc(size);
	int* mtrx=(int*)malloc(size*n);

	for(int i=0;i<n;i++){
		for(int j=0;j<n;j++)
			mtrx[i*n+j]=(i==j)?(1):(0);
		vec[i]=i;
	}

	int* cuVec=NULL;
	int* cuAns=NULL;
	int* cuMtrx=NULL;
	cuAssert(cudaMalloc((void**)&cuVec,size));
	cuAssert(cudaMalloc((void**)&cuAns,size));
	cuAssert(cudaMalloc((void**)&cuMtrx,size*n));

	cuAssert(cudaMemcpy(cuMtrx,mtrx,size*n,cudaMemcpyHostToDevice));
	cuAssert(cudaMemcpy(cuVec,vec,size,cudaMemcpyHostToDevice));

	dim3 grid((n+BLOCK_SIZE-1)/BLOCK_SIZE,1,1);
	dim3 block(BLOCK_SIZE,1,1);

//coalesced block 1D indexes
	cuAssert(cudaEventRecord(start));
	mtrxToVec<<<grid,block>>>(cuMtrx,cuVec,cuAns,n);
	cuAssert(cudaEventRecord(stop));
	cuAssert(cudaEventSynchronize(stop));
	cuAssert(cudaEventElapsedTime(&time,start,stop));
	printf("coalesced time X %f\n",time);
	cuAssert(cudaGetLastError());
	cuAssert(cudaMemcpy(ans,cuAns,size,cudaMemcpyDeviceToHost));
	//print(ans,n);

	dim3 gridY(1,(n+BLOCK_SIZE-1)/BLOCK_SIZE,1);
	dim3 blockY(1,BLOCK_SIZE,1);	
	cuAssert(cudaEventRecord(start));
	mtrxToVecY<<<gridY,blockY>>>(cuMtrx,cuVec,cuAns,n);
	cuAssert(cudaEventRecord(stop));
	cuAssert(cudaEventSynchronize(stop));
	cuAssert(cudaEventElapsedTime(&time,start,stop));
	printf("coalesced time Y %f\n",time);
	cuAssert(cudaGetLastError());
	
//Non coalesced block
	cuAssert(cudaEventRecord(start));
	transposeMtrxToVec<<<grid,block>>>(cuMtrx,cuVec,cuAns,n);
	cuAssert(cudaEventRecord(stop));
	cuAssert(cudaEventSynchronize(stop));
	cuAssert(cudaEventElapsedTime(&time,start,stop));
	printf("non coalesced time %f\n",time);
	cuAssert(cudaGetLastError());

	cuAssert(cudaFree(cuVec));
	cuAssert(cudaFree(cuAns));
	cuAssert(cudaFree(cuMtrx));

	free(vec);
	free(ans);
	free(mtrx);
	return 0;
}
