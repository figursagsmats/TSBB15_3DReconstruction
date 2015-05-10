/*
** This routine will combine a set of fixed filter responses
** into an adaptive filter response using the control tensor C.
**
**  C    should contain tensors in T6 format.
**  S    should contain the precomputed fixed filter responses.
**  AHP  is the amplification factor for the high-pass content
**       of the signal.
**
**  by Per-Erik Forssén
**
** Compile command: mex CC=gcc syntFilt3D.c
*/
#include "mex.h"
#include <math.h>
#include <malloc.h>

/*
** Function to construct dual tensors for six symmetrically
** placed orientations.
** NOTE: The dual tensors are in compacted form, and are
**       scaled with ocurrence.
*/
void findBasis(double *db_array)
{
double a,b,c;
double n[3*6]; /* [coeff+3*dir] */
double *ni,*Mi;
int ind;

   a = 2.0;                    /* see p 237 in Computer Vision book */
   b = (1.0+sqrt(5.0)); 
   c = 1.0/sqrt(a*a + b*b);
   a = a*c; b = b*c;

   n[0+0*3]= 0;n[1+0*3]= a;n[2+0*3]= b;  /* filter dir [y x z] */
   n[0+1*3]= 0;n[1+1*3]=-a;n[2+1*3]= b;
   n[0+2*3]= a;n[1+2*3]= b;n[2+2*3]= 0;
   n[0+3*3]=-a;n[1+3*3]= b;n[2+3*3]= 0;
   n[0+4*3]= b;n[1+4*3]= 0;n[2+4*3]= a;
   n[0+5*3]= b;n[1+5*3]= 0;n[2+5*3]=-a;

   for(ind=0;ind<6;ind++) {
     ni=&n[0+ind*3];
     Mi=&db_array[0+ind*6];
     
     Mi[0] = 5.0/4.0*ni[0]*ni[0] - 0.25;     /* posn x11 */
     Mi[1] = 5.0/4.0*ni[1]*ni[1] - 0.25;     /* posn x22 */
     Mi[2] = 5.0/4.0*ni[2]*ni[2] - 0.25;     /* posn x33 */
     Mi[3] = 5.0/4.0*ni[0]*ni[1]*2.0;        /* 2 * posn x12 */
     Mi[4] = 5.0/4.0*ni[0]*ni[2]*2.0;        /* 2 * posn x13 */
     Mi[5] = 5.0/4.0*ni[1]*ni[2]*2.0;        /* 2 * posn x23 */
   }
}
/*
** Function to synthesize the output from the adaptive filter
**
*/
void syntFilt3D(double *fixr,double *ctens,double ahp,int ysz,int xsz,
		int zsz,unsigned char *result)
{
double db_array[6*6];
int x,y,z,ind,filt;
int cpoint,volsz;
double MtimesC,thisPoint;

  findBasis(db_array);
/*  for(y=0;y<6;y++) {
    for(x=0;x<6;x++) mexPrintf("%f ",db_array[y+x*6]);
    mexPrintf("\n");
  } */

  volsz=xsz*ysz*zsz;
  for(y=0;y<ysz;y++)
    for(x=0;x<xsz;x++)
      for(z=0;z<zsz;z++) {
	cpoint= y + ysz*(x + xsz*z);
	thisPoint = 0.0;
	for(filt=0;filt<6;filt++) {
	  MtimesC=0.0;
	  for(ind=0;ind<6;ind++) {
	    MtimesC += ctens[ind*volsz + cpoint]*db_array[ind + filt*6];
	  }
	  thisPoint += MtimesC*fixr[cpoint + volsz*(filt+1)];
	}
	/*thisPoint = rint(fixr[cpoint]+ahp*thisPoint);*/
	/* FIX for getting to compile in LCC */
	thisPoint = floor(fixr[cpoint]+ahp*thisPoint+0.5);
	if(thisPoint<0.0) thisPoint = 0.0;
	if(thisPoint>255.0) thisPoint = 255.0;
	result[cpoint] = thisPoint;
      }
}
/*
** Function to check wether an argument has
** the correct sizes in all dimensions. 
** -1 as size means any size. MSIZE is the
** size that ARG should match.
*/
int hasSize(const mxArray *arg,int *msize,int ndims)
{
const int *dims;
int retval;
  dims = mxGetDimensions(arg);
  retval=1;
  if(mxGetClassID(arg) != mxDOUBLE_CLASS) retval=0;
  if(mxGetNumberOfDimensions(arg) != ndims) retval=0;
  if((msize[0] != -1) && (dims[0] != msize[0])) retval=0;
  if((msize[1] != -1) && (dims[1] != msize[1])) retval=0;
  if((msize[2] != -1) && (dims[2] != msize[2])) retval=0;
  if((msize[3] != -1) && (dims[3] != msize[3])) retval=0;
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
const int *dims,*dims2;
int msize[4];
double *fixr,*ctens,*pahp;
mxArray *mx_result;
double ahp;
unsigned char *result;
/*
** Argument type and count checking:
*/
   if(nrhs != 3) {
     if(nrhs !=0) mexErrMsgTxt("Three arguments expected.\n");
     goto mexErrExit;
   }

   msize[0]=msize[1]=1;msize[2]=msize[3]=-1;
   if(!hasSize(prhs[2],msize,2))
     mexErrMsgTxt("The argument <ahp> should be a scalar.\n");
   
   msize[0]=msize[1]=msize[2]=-1;msize[3]=6;
   if(!hasSize(prhs[1],msize,4)) 
     mexErrMsgTxt("Type mismatch: The <C> argument should be a MxNxOx6 double matrix.\n");

   msize[0]=msize[1]=msize[2]=-1;msize[3]=7;
   if(!hasSize(prhs[0],msize,4)) 
     mexErrMsgTxt("Type mismatch: The <S> argument should be a MxNxOx7 double matrix.\n");

/*
** Check that S and C are compatible
*/
   dims = mxGetDimensions(prhs[0]);     /* S size */
   dims2 = mxGetDimensions(prhs[1]);    /* C size */
   if((dims[0]!=dims2[0])||(dims[1]!=dims2[1])||(dims[2]!=dims2[2]))
       mexErrMsgTxt("Error: <S> and <C> have incompatible sizes.\n");


/*
** Get parameters and call the computation function.
*/

   msize[0]=(int)dims[0];
   msize[1]=(int)dims[1];
   msize[2]=(int)dims[2];
   mx_result = mxCreateNumericArray(3,msize,mxUINT8_CLASS,mxREAL);
   result=(unsigned char *)mxGetPr(mx_result);
   fixr  = mxGetPr(prhs[0]);  /* Fixed filter responses */
   ctens = mxGetPr(prhs[1]);  /* Control tensor field   */
   pahp  = mxGetPr(prhs[2]);
   ahp   = pahp[0];           /* The highpass amplification parameter. */
   
   syntFilt3D(fixr,ctens,ahp,dims[0],dims[1],dims[2],result);
   plhs[0] = mx_result;



/*
** End of function
*/
   goto mexExit;
mexErrExit:
     mexPrintf("Usage: <IM> = syntFilt3D(<S>,<C>,<ahp>)\n");
mexExit: {}
}

