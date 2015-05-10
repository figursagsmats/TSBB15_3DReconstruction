/*
** Routine to initialize the parameters for the m map function.
**
**  by Per-Erik Forssén
**
** Compile command: mex CC=gcc msetup.c
*/
#include "mex.h"
#include <math.h>
#include <malloc.h>
/*
** Function to check that the argument variable is
** a scalar of class mxDOUBLE_CLASS.
*/
int isScalar(const mxArray *parameter)
{
  const int *dims;
  int retval;

  retval=1;       /* First assume double scalar */
  dims = mxGetDimensions(parameter);
  if(mxGetClassID(parameter) != mxDOUBLE_CLASS)
    retval=0;     /* Not double */
  if((mxGetNumberOfDimensions(parameter) > 2) ||
     (dims[0] != 1) || (dims[0] != dims[1]) )
    retval=0;     /* Not scalar */
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
mxArray *variable;
double  *pr;
/*
** First check the number of input arguments:
*/
   if(nrhs != 4) {
     goto mexErrExit;
   }
/*
** Now we do some typechecking of what MATLAB has supplied us with:
*/
   if(!isScalar(prhs[0])) {
     mexPrintf("Type mismatch: <sigma> should be a scalar.\n\n");
     goto mexErrExit;
   }
   if(!isScalar(prhs[1])) {
     mexPrintf("Type mismatch: <alpha> should be a scalar.\n\n");
     goto mexErrExit;
   }
   if(!isScalar(prhs[2])) {
     mexPrintf("Type mismatch: <beta> should be a scalar.\n\n");
     goto mexErrExit;
   }
   if(!isScalar(prhs[3])) {
     mexPrintf("Type mismatch: <j> should be a scalar.\n\n");
     goto mexErrExit;
   }
/*
** Now we should move the arguments into new variables.
*/
/*
**  <sigma>
*/
   variable = mxCreateDoubleMatrix(1, 1, mxREAL);
   mxSetName(variable, "adm_sigma");
   pr = mxGetPr(variable);
   memcpy((void *)pr,(const void *)mxGetPr(prhs[0]),sizeof(double));
   mexPutArray(variable, "caller");
/*
**  <alpha>
*/
   variable = mxCreateDoubleMatrix(1, 1, mxREAL);
   mxSetName(variable, "adm_alpha");
   pr = mxGetPr(variable);
   memcpy((void *)pr,(const void *)mxGetPr(prhs[1]),sizeof(double));
   mexPutArray(variable, "caller");
/*
**  <beta>
*/
   variable = mxCreateDoubleMatrix(1, 1, mxREAL);
   mxSetName(variable, "adm_beta");
   pr = mxGetPr(variable);
   memcpy((void *)pr,(const void *)mxGetPr(prhs[2]),sizeof(double));
   mexPutArray(variable, "caller");
/*
**  <j>
*/
   variable = mxCreateDoubleMatrix(1, 1, mxREAL);
   mxSetName(variable, "adm_j");
   pr = mxGetPr(variable);
   memcpy((void *)pr,(const void *)mxGetPr(prhs[3]),sizeof(double));
   mexPutArray(variable, "caller");
/*
** End
*/
   goto mexExit;
mexErrExit:
   mexPrintf("Usage: msetup(<sigma>, <alpha>, <beta>, <j>);\n");
mexExit: {}
}

