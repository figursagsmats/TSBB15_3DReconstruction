/*
** Routine to remap the eigenvalues of a 2D control tensor field,
** according to the map functions m and my.
** The parameters for m and my should have been setup beforehand
** using MSETUP and MYSETUP.
**
**  by Per-Erik Forssén
**
** Compile command: mex CC=gcc tensMap2D.c
*/
#include "mex.h"
#include <math.h>
#include <malloc.h>

/*
** Computation of the map function m
*/
double mmap(double Tnorm,double sigma,double alpha,double beta,double j)
{
double gamma,temp;
   if(Tnorm==0) {
     gamma = 0.0;
   } else {
     temp = log(Tnorm);
     if(sigma==0) {
       temp=exp(-alpha*temp);
     } else {
       temp = exp(beta*temp)/(exp((beta+alpha)*temp)+exp(beta*log(sigma)));
     }
     gamma = exp(log(temp)/j);
   }
   return gamma;
}
/*
** Computation of the map function my
*/
double mymap(double ratio,double alpha,double beta,double j)
{
double my,temp;

   temp = exp(beta*log(ratio*(1-alpha)))/(exp(beta*log(ratio*(1-alpha)))+
					 exp(beta*log(alpha*(1-ratio))));
   my = exp(log(temp)/j);
   return my;
}
/*
** Remapping routine
** Tnew = alpha*Told + beta*I
*/
void remap_tensor(double *newtens,double *oldtens,double alpha,double beta)
{
   newtens[0]=oldtens[0]*alpha+beta;
   newtens[1]=oldtens[1]*alpha;
   newtens[2]=oldtens[2]*alpha+beta;
}
/*
** compute eigenvalues
** NOTE: in case the eigenvalues are negative (this CAN happen!)
**       this function will return negative eigenvalues.
**       By supplying the map function with only the
**       absolute values, the remapped tensor should have
**       only positive eigenvalues.
*/
void calc_eigval(double *in_tens,double *eigval)
{
double Tnorm2,det2T;
double a,b;

   Tnorm2=in_tens[0]*in_tens[0]+2*in_tens[1]*in_tens[1]+in_tens[2]*in_tens[2];
   det2T = 2*(in_tens[0]*in_tens[2] - in_tens[1]*in_tens[1]);
   a=sqrt(Tnorm2+det2T); /* = lambda1+lambda2 */
/*
** the fabs call below is needed for those rare cases
** where norm^2<2*det (other solutions are welcome)
*/
   b=sqrt(fabs(Tnorm2-det2T)); /* = lambda1-lambda2 */
   eigval[0]=(a+b)/2;
   eigval[1]=(a-b)/2;
}
/*
** Main computation routine
*/
void tensMap2D(double *in_tens,double *out_tens,int ysz,int xsz,
		  double adm_sigma,double adm_alpha,double adm_beta,
		  double adm_j,double admy_alpha,double admy_beta,
		  double admy_j)
{
int x,y;
double oldtens[3],newtens[3];
double eigval[2];
double gamma1,gamma2;
double alpha,beta;
double Tnorm;

   for(x=0;x<xsz;x++) {
     for(y=0;y<ysz;y++) {
       oldtens[0]=in_tens[y+x*ysz]; /* Arguments for the computations */
       oldtens[1]=in_tens[y+x*ysz+xsz*ysz];
       oldtens[2]=in_tens[y+x*ysz+2*xsz*ysz];
/*
** Remap each tensor
*/
       calc_eigval(oldtens,eigval);
       Tnorm=sqrt(eigval[0]*eigval[0]+eigval[1]*eigval[1]);
       gamma1=mmap(Tnorm,adm_sigma,adm_alpha,adm_beta,adm_j);
       gamma2=gamma1*mymap(fabs(eigval[1]/eigval[0]),admy_alpha,admy_beta,admy_j);
       alpha=(gamma1-gamma2)/(eigval[0]-eigval[1]);
       beta=gamma1-alpha*eigval[0];

       if(eigval[0]==eigval[1]) {
/*
** Completely isotropic tensor needs special treatment
** Tremap(Tiso) = gamma1*I
*/
	 newtens[0]=newtens[2]=gamma1;
	 newtens[1]=0;
       } else
	 remap_tensor(newtens,oldtens,alpha,beta);
/*
** Store results
*/
       out_tens[y+x*ysz]=newtens[0];
       out_tens[y+x*ysz+xsz*ysz]=newtens[1];
       out_tens[y+x*ysz+2*xsz*ysz]=newtens[2];       
     }
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
** Function to fetch a double variable by name
** from the Matlab workspace.
** returns pointer to value, or NULL.
*/
double *getValue(char *varname)
{
  mxArray *var_ptr;
  var_ptr = mexGetArray(varname, "caller");
  if (var_ptr == NULL) return NULL;
  return mxGetPr(var_ptr);
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
double *tensor,*result;
mxArray *mx_result;
double temp; /* Just checking how log and exp works */
/*
** Variables fetched from within Matlab
*/
double *adm_sigma;
double *adm_alpha;
double *adm_beta;
double *adm_j;
double *admy_alpha;
double *admy_beta;
double *admy_j;
/*
** Try to fetch the parameters that should have been
** initialized by MSETUP and MYSETUP
*/
   if((adm_sigma  = getValue("adm_sigma")) ==NULL) goto mexNosetup;
   if((adm_alpha  = getValue("adm_alpha")) ==NULL) goto mexNosetup;
   if((adm_beta   = getValue("adm_beta"))  ==NULL) goto mexNosetup;
   if((adm_j      = getValue("adm_j"))     ==NULL) goto mexNosetup;
   if((admy_alpha = getValue("admy_alpha"))==NULL) goto mexNosetup;
   if((admy_beta  = getValue("admy_beta")) ==NULL) goto mexNosetup;
   if((admy_j     = getValue("admy_j"))    ==NULL) goto mexNosetup;
/*
** Argument type and count checking:
*/
   if(nrhs != 1) {
     if(nrhs !=0) mexPrintf("Error: Wrong number of input arguments.\n");
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
** Fetch the argument, and call the computation function
*/
   dims = mxGetDimensions(prhs[0]);
   mx_result = mxCreateNumericArray(3,dims,mxDOUBLE_CLASS,mxREAL);
   result=(double *)mxGetPr(mx_result);
   tensor = mxGetPr(prhs[0]);
   tensMap2D(tensor,result,dims[0],dims[1],*adm_sigma,*adm_alpha,
		*adm_beta,*adm_j,*admy_alpha,*admy_beta,*admy_j);
   plhs[0] = mx_result;
/*
** The required parameters were not initialized
*/
   goto mexExit;
mexNosetup:
   mexPrintf("The map functions are not initialized.\n");
   mexPrintf("Please make sure you have run msetup and mysetup,\n");
   mexPrintf("then try again.\n");
   goto mexExit;
  mexErrExit:
     mexPrintf("Usage: <T3> = tensMap2D(<T3>)\n");
mexExit: {}
}

