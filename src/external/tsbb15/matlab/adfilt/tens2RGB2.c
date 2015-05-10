/*
** This routine converts a T3 tensor field to RGB in a manner
** similar to that in the colour representation scheme in Colour
** image3.
**
** The energy in four directions are represented by four colours.
**
** i.e, G=[1 0] B=1/sqrt(2)*[1 1] R=[0 1] Y=1/sqrt(2)*[-1 1]
** 
**  by Per-Erik Forssén
**
** Compile command: mex CC=gcc tens2RGB.c
*/
#include "mex.h"
#include <math.h>
#include <malloc.h>

/*
** Computation of colour for one pixel
*/
double *T3toRGB(double *T3,double *RGB)
{
int ind;
static double M1[3] = {1.0,0.0,-1.0/3.0};     /* Red */
static double M2[3] = {-1.0/3.0,0.0,1.0};     /* Green */
static double M3[3] = {1.0/3.0,-2.0/3.0,1.0/3.0}; /* Blue */
static double M4[3] = {1.0/3.0,2.0/3.0,1.0/3.0};  /* Yellow */
double Tc[3];  /* Tensor wheighted with occurence */
  Tc[0]=T3[0];
  Tc[1]=2*T3[1];
  Tc[2]=T3[2];
  RGB[0]=0;
  RGB[1]=0; 
  RGB[2]=0;
  for(ind=0;ind<3;ind++) {
    RGB[0]+=Tc[ind]*M1[ind]+Tc[ind]*M4[ind]*0.70710678118655;
    RGB[1]+=Tc[ind]*M2[ind]+Tc[ind]*M4[ind]*0.70710678118655;
    RGB[2]+=Tc[ind]*M3[ind];
  }
  for(ind=0;ind<3;ind++) {
    if(RGB[ind]<0) RGB[ind]=-RGB[ind];
  }
  return RGB;
}
/*
** Main computation routine
*/
void RGBshow(double *tens,double *RGB,int ys,int xs)
{
int x,y,c,ind;
double ctens[3];
static double temp[3];
   for(x=0;x<xs;x++)
     for(y=0;y<ys;y++) {
       ctens[0]=tens[x*ys+y];
       ctens[1]=tens[x*ys+y+xs*ys];
       ctens[2]=tens[x*ys+y+2*xs*ys];
       T3toRGB(ctens,temp);
       if(temp[0]>1.0) temp[0]=1.0;
       if(temp[1]>1.0) temp[1]=1.0;
       if(temp[2]>1.0) temp[2]=1.0;
       RGB[x*ys+y]=temp[0];
       RGB[x*ys+y+xs*ys]=temp[1];
       RGB[x*ys+y+xs*ys*2]=temp[2];
     }
}
/*
** Function to check wether an argument is
** a double 3d matrix of given size
** -1 as size means any size
*/
int hasSize(const mxArray *arg,int *msize)
{
const int *dims;
int retval;
  dims = mxGetDimensions(arg);
  retval=1;
  if(mxGetClassID(arg) != mxDOUBLE_CLASS) retval=0;
  if(mxGetNumberOfDimensions(arg) != 3) retval=0;
  if((msize[0] != -1) && (dims[0] != msize[0])) retval=0;
  if((msize[1] != -1) && (dims[1] != msize[1])) retval=0;
  if((msize[2] != -1) && (dims[2] != msize[2])) retval=0;
  return retval;
}

/*
** mexFunction is the interface function to MATLAB.
**
** plhs - pointer to left-hand OUTPUT mxArrays
** nlhs - number of left-hand OUTPUT arrays
** prhs - pointer to right-hand INPUT mxArrays
** nrhs - number of right-hand INPUT arrays
**
*/
void mexFunction( int nlhs, mxArray *plhs[],
             int nrhs, const mxArray *prhs[] )
{
const int *dims;
int msize[3];
double *result;
mxArray *mx_result;
int filtercnt;
/*
** Argument count check:
*/
   if(nrhs != 1) {
     if(nrhs !=0) mexPrintf("Error: One input argument expected.\n");
     goto mexErrExit;
   }
/*
** Check the argument type:
*/
  msize[0]=-1;msize[1]=-1;msize[2]=3;
  if(!hasSize(prhs[0],msize)) {
    mexPrintf("Type mismatch: <T> should be a mxnx3 double matrix.\n");
    goto mexErrExit;
  }
/*
** Fetch the arguments, and call the computation function
*/
   dims = mxGetDimensions(prhs[0]);
   msize[0]=dims[0];msize[1]=dims[1];msize[2]=3;
   mx_result = mxCreateNumericArray(3,msize,mxDOUBLE_CLASS,mxREAL);
   result=(double *)mxGetPr(mx_result);
   RGBshow(mxGetPr(prhs[0]),result,msize[0],msize[1]);
   plhs[0] = mx_result;
/*
** Jump to normal exit
*/
   goto mexExit;
  mexErrExit:
     mexPrintf("Usage: <RGB> = tens2RGB(<T3>)\n");
mexExit: {}
}





