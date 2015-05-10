/*************************************************************
*
* tensConv3 - Convolution, in three dimensions. 
* This function is optimized for kernels with lots of zeros.
* Arguments can be real or complex.
* original implementation M Hemmendorff
*
* compile command:    mex CC=gcc tensConv3.c
*
************************************************************/

/* #include <math.h> */
#include "mex.h"


#define my_max(a,b) (  ((a)>(b)) ? (a) : (b) )
#define my_min(a,b) (  ((a)<(b)) ? (a) : (b) )
/* The following constants are the parameter numbers */
#define P_SIGNAL 0
#define P_KERNEL 1
#define NUM_IN 2
#define NUM_OUT 1

#define DIMENSIONS 3  /*Do not change. Code is hardwired*/



void 
#ifdef __STDC__
CheckParameters(int nlhs,						
		mxArray	*plhs[],
		int nrhs,	
		mxArray	*prhs[]
		)
#else
CheckParameters(nlhs, plhs, nrhs,prhs)
int nlhs;
mxArray	*plhs[];
int nrhs;
mxArray	*prhs[];
#endif
  {

  if(nrhs != NUM_IN)
    mexErrMsgTxt("Wrong number of input arguments in function call.\n");
  if(nlhs != NUM_OUT)
    mexErrMsgTxt("Wrong number of output matrices in function call.\n");

  if(mxGetNumberOfDimensions (prhs[P_SIGNAL]) != DIMENSIONS)
    mexErrMsgTxt("The signal must be 3D.");

  
  if(mxGetNumberOfDimensions (prhs[P_KERNEL]) > DIMENSIONS)
    mexErrMsgTxt("The kernel must have at most 3 dimensions.");
  if(mxGetNumberOfDimensions (prhs[P_KERNEL]) < 1)
    mexErrMsgTxt("The kernel must have at least 1 dimension.");
}

/*
** Convolve one kernel value with the signal.
*/
void 
#ifdef __STDC__
ConvInnerREAL(double *signal, int ssize[],
	      double value, int shift[],
	      double *outSignal)
#else
ConvInnerREAL(signal,ssize,value,shift,outSignal)
double *signal;
int ssize[]; /* Size of input signal */
double value;
int shift[]; /* Kernel indices with zero in the center of the kernel */
double *outSignal;
#endif
 {
  int s[DIMENSIONS];
  int readIndex;
  int shiftIndex;
  int loopstart[DIMENSIONS];
  int loopstop[DIMENSIONS];

  shiftIndex = shift[0] + ssize[0]*(shift[1] + ssize[1]*shift[2]);
  loopstart[0] = my_max(0, -shift[0]); /* "-" due to the convolution */
  loopstart[1] = my_max(0, -shift[1]);
  loopstart[2] = my_max(0, -shift[2]);
  loopstop[0] = ssize[0]-my_max(0,shift[0]);
  loopstop[1] = ssize[1]-my_max(0,shift[1]);
  loopstop[2] = ssize[2]-my_max(0,shift[2]);

  for(s[2]=loopstart[2]; s[2]<loopstop[2]; s[2]++) {
    for(s[1]=loopstart[1]; s[1]<loopstop[1]; s[1]++) {
      for(s[0]=loopstart[0]; s[0]<loopstop[0]; s[0]++) {
	readIndex = s[0] + ssize[0]*(s[1] + ssize[1]*s[2]);  /* This can be speeded up */
	outSignal[readIndex+shiftIndex] += value*signal[readIndex];
      }
    }
  }
 }

void
#ifdef __STDC__
ConvInnerCOMPLEX(double *signalR, /*double *signalI,*/ int ssize[],
	      double valueR, double valueI,int shift[],
	      double *outSignalR, double *outSignalI) 
#else
ConvInnerCOMPLEX(signalR, /*signalI,*/ ssize,
	      valueR,valueI,shift,
	      outSignalR,outSignalI) 
double *signalR;
/*double *signalI;*/
int ssize[];
double valueR;
double valueI;
int shift[]; /* Kernel indices with zero in the center of the kernel */
double *outSignalR;
double *outSignalI; 
#endif
{
  int s[DIMENSIONS];
  int readIndex;
  int shiftIndex;
  int loopstart[DIMENSIONS];
  int loopstop[DIMENSIONS];

  shiftIndex = shift[0] + ssize[0]*(shift[1] + ssize[1]*shift[2]);
  loopstart[0] = my_max(0, -shift[0]);
  loopstart[1] = my_max(0, -shift[1]);
  loopstart[2] = my_max(0, -shift[2]);
  loopstop[0] = ssize[0]-my_max(0,shift[0]);
  loopstop[1] = ssize[1]-my_max(0,shift[1]);
  loopstop[2] = ssize[2]-my_max(0,shift[2]);

  for(s[2]=loopstart[2]; s[2]<loopstop[2]; s[2]++) {
    for(s[1]=loopstart[1]; s[1]<loopstop[1]; s[1]++) {
      for(s[0]=loopstart[0]; s[0]<loopstop[0]; s[0]++) {
	readIndex = s[0] + ssize[0]*(s[1] + ssize[1]*s[2]);  /* This can be speeded up */
	outSignalR[readIndex+shiftIndex] += 
	  valueR*signalR[readIndex] /*- valueI*signalI[readIndex]*/;
	outSignalI[readIndex+shiftIndex] += 
	  /*valueR*signalI[readIndex] +*/ valueI*signalR[readIndex];
      }
    }
  }
}




mxArray *
#ifdef __STDC__
ConvMainREAL(double *signal, int ssize[],
	     double *kernel, int ksize[])
#else
ConvMainREAL(signal,ssize,
	     kernel,ksize)
double *signal;
int ssize[];
double *kernel;
int ksize[];
#endif
{
  mxArray *retmxArray;
  double *outSignal;
  int kcenter[DIMENSIONS]; /* "origin" coordinates in the kernel */
  int k[DIMENSIONS];       /* loop counters */
  int index;               /* trash */
  int shift[DIMENSIONS];   /* argument to the inner loop */
  double value;

  /* The output matrix has the same size as the input one */ 
  retmxArray = mxCreateNumericArray(DIMENSIONS, ssize, mxDOUBLE_CLASS, mxREAL);
  outSignal = mxGetPr(retmxArray);
  kcenter[0] = ksize[0] / 2;
  kcenter[1] = ksize[1] / 2;
  kcenter[2] = ksize[2] / 2;


  for(k[2]=0;k[2]<ksize[2];k[2]++)
    for(k[1]=0;k[1]<ksize[1];k[1]++)
      for(k[0]=0;k[0]<ksize[0];k[0]++) {
	index = k[0] + ksize[0]*(k[1]+ksize[1]*k[2]);
	value=kernel[index];
	if(value==0) /* Avoid unnecessary computations */ 
	  continue; 
	shift[0] = k[0] - kcenter[0];
	shift[1] = k[1] - kcenter[1];
	shift[2] = k[2] - kcenter[2];
	ConvInnerREAL(signal, ssize, value, shift, outSignal);
      }
  return(retmxArray);
}

mxArray*
#ifdef __STDC__
ConvMainCOMPLEX(double *signalR, /*double *signalI, */ int ssize[],
		double *kernelR, double *kernelI, int ksize[])
#else
ConvMainCOMPLEX(signalR,/* signalI, */ ssize,
		kernelR, kernelI, ksize) 
double *signalR;
/*double *signalI;*/
int ssize[];
double *kernelR;
double *kernelI;
int ksize[];
#endif 
{
  mxArray *retmxArray;
  double *outSignalR, *outSignalI;
  int kcenter[DIMENSIONS]; /* "origin" coordinates in the kernel */
  int k[DIMENSIONS];       /* loop counters */
  int index;               /* trash */
  int shift[DIMENSIONS];   /* argument to the inner loop */
  double valueR, valueI;

  /* The output matrix has the same size as the input one */
  retmxArray = mxCreateNumericArray(DIMENSIONS, ssize, mxDOUBLE_CLASS, mxCOMPLEX);

  outSignalR = mxGetPr(retmxArray);
  outSignalI = mxGetPi(retmxArray);
  kcenter[0] = ksize[0] / 2;
  kcenter[1] = ksize[1] / 2;
  kcenter[2] = ksize[2] / 2;

  for(k[2]=0;k[2]<ksize[2];k[2]++)
    for(k[1]=0;k[1]<ksize[1];k[1]++)
      for(k[0]=0;k[0]<ksize[0];k[0]++) {
	index = k[0] + ksize[0]*(k[1]+ksize[1]*k[2]);
	valueR=kernelR[index];
	valueI=kernelI[index];
	/* Avoid unnecessary computations */
	if( (valueR==0) && (valueI==0))
	  continue;
	shift[0] = k[0] - kcenter[0];
	shift[1] = k[1] - kcenter[1];
	shift[2] = k[2] - kcenter[2];

	ConvInnerCOMPLEX(signalR, /*signalI,*/ ssize, 
			 valueR, valueI, shift, 
			 outSignalR,outSignalI );
      }
  return(retmxArray);
}


/* ================================================================= */
/*
** mexFunction is the interface function to MATLAB.
**
** plhs - pointer to left-hand OUTPUT mxArrays
** nlhs - number of left-hand OUTPUT arrays
** prhs - pointer to right-hand INPUT mxArrays
** nrhs - number of right-hand INPUT arrays
**
*/
#ifdef __STDC__
void mexFunction(int	nlhs,
	    mxArray *plhs[],
	    int	nrhs,
	    const mxArray *prhs[] ) 
#else
void mexFunction(nlhs, plhs, nrhs,prhs)
int nlhs, nrhs;
mxArray *plhs[];
const mxArray *prhs[];
#endif
{
  int ksize[DIMENSIONS];
  int i;
  const int* tmp = mxGetDimensions(prhs[P_KERNEL]);
  for(i = 0; i < DIMENSIONS; i++) {
	if ( i < mxGetNumberOfDimensions(prhs[P_KERNEL]) )
		ksize[i] = tmp[i];
	else
		ksize[i] = 1;
  }

  CheckParameters(nlhs, plhs,nrhs,prhs);  /* Terminates if error */

  if(mxIsComplex(prhs[P_KERNEL])) {
    /* Matlab: If one argument has a imaginary part, then all arguments have.
     - Either we have complex*complex or real*real */

	  plhs[0] = ConvMainCOMPLEX(mxGetPr(prhs[P_SIGNAL]), 
			      /* mxGetPi(prhs[P_SIGNAL]), */
			      mxGetDimensions(prhs[P_SIGNAL]),
			      mxGetPr(prhs[P_KERNEL]),  
			      mxGetPi(prhs[P_KERNEL]),
			      ksize );
  }
  else {
    plhs[0] = ConvMainREAL(mxGetPr(prhs[P_SIGNAL]), 
		                   mxGetDimensions(prhs[P_SIGNAL]),
						   mxGetPr(prhs[P_KERNEL]), 
						   ksize );
  }
  /* plhs[0] is returned value to Matlab*/
}

