/*
** Routine to remap the eigenvalues of the control tensor,
** according to the map functions m and my.
** The parameters for m and my should have been setup beforehand
** using MSETUP and MYSETUP.
** This routine does not call the Matlab EIG function
** Speedup: 4.79 times compared to Matlab
**
**  by Per-Erik Forssén
**
** Compile command: mex CC=gcc tensMap3D.c
*/
#include "mex.h"
#include <math.h>
#include <malloc.h>
#ifndef PI
#define PI 3.14159265358979306187484326
#endif
#define R3D2 0.8660254037844385518241
/*
** Remapping routine
** Tnew = alpha*Told + beta*I + delta*Told*Told
*/
void remap_tensor(double *newtens,double *oldtens,double alpha,double beta,
		  double delta)
{
double Tsq[6];
double a,b,c,d,e,f;
    a=oldtens[0];
    b=oldtens[1];
    c=oldtens[2];
    d=oldtens[3];
    e=oldtens[4];
    f=oldtens[5];
    Tsq[0]=a*a+d*d+e*e;  /* Compute T*T */
    Tsq[1]=d*d+b*b+f*f;
    Tsq[2]=e*e+f*f+c*c;
    Tsq[3]=a*d+b*d+f*e;
    Tsq[4]=a*e+d*f+c*e;
    Tsq[5]=d*e+b*f+c*f;
    newtens[0]=a*alpha+Tsq[0]*delta+beta;
    newtens[1]=b*alpha+Tsq[1]*delta+beta;
    newtens[2]=c*alpha+Tsq[2]*delta+beta;
    newtens[3]=d*alpha+Tsq[3]*delta;
    newtens[4]=e*alpha+Tsq[4]*delta;
    newtens[5]=f*alpha+Tsq[5]*delta;
}
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
** Compute eigenvalues
** See "Spatial Domain Methods for Orientation and
** Velocity Estimation" By Gunnar Farnebäck (pp 100-102)
** LIU-TEK-LIC-1999:13
** ISBN 91-7219-441-3
**
** in_tens indices are:
**      0 3 4
**      3 1 5
**      4 5 2
**
** The eigenvalues returned are sorted in decreasing order
*/
void calc_eigval(double *in_tens,double *eigval)
{
double a,b,c,d,e,f,tr3;
double p,q,alpha,beta;
int im,ix;
   a=in_tens[0];
   b=in_tens[1];
   c=in_tens[2];
   d=in_tens[3];
   e=in_tens[4];
   f=in_tens[5];
   tr3=(a+b+c)/3.0;
   a=a-tr3;b=b-tr3;c=c-tr3;
   p=a*b-d*d+a*c-e*e+b*c-f*f;
   q=a*f*f-2*d*e*f+b*e*e-a*b*c+c*d*d;
   beta=sqrt(-4.0*p/3.0);
   alpha=3.0*q/p/beta;
   if(alpha>1.0) alpha=1.0;
   alpha=1.0/3.0*acos(alpha);
   eigval[0]=beta*cos(alpha)+tr3;
   eigval[1]=beta*cos(alpha-2.0*PI/3.0)+tr3;
   eigval[2]=beta*cos(alpha+2.0*PI/3.0)+tr3;
}
/*
** Main computation routine for tensMap3D
** if slice != -1 just this one slice will be computed
*/
void tensMap3D(double *in_tens,double *out_tens,int ysz,int xsz,int zsz,
	       double adm_sigma,double adm_alpha,double adm_beta,double adm_j,
	       double admy_alpha,double admy_beta,double admy_j,int slice)
{
  int x,y,z;
  int zstart,zend,zoffset,thisind,volsz,outvolsz;
  double gamma[3],eigval[3];
  double oldtens[6],newtens[6];
  double my2,my3,Tnorm;
  double alpha,beta,delta;
  double l1,l2,l3,g1,g2,g3;

  if(slice == -1) {     /* compute full volume */
    zstart = 0;
    zend = zsz;
    zoffset = xsz*ysz;  /* size of each slice */
    outvolsz = xsz*ysz*zsz;  /* size of output volume */
  } else {              /* just one slice */
    zstart = slice-1;   /* c indices start with 0, matlab starts with 1 */
    zend = slice;
    zoffset = 0;        /* use only zindex 0 in out_tens */
    outvolsz = xsz*ysz; /* size of output volume */
  } 
  volsz=xsz*ysz*zsz;
  for(z=zstart;z<zend;z++) {
    for(y=0;y<ysz;y++) {
      for(x=0;x<xsz;x++) {
	thisind=y+x*ysz+z*xsz*ysz;
	oldtens[0]=in_tens[thisind]; /* Args for computations */
	oldtens[1]=in_tens[thisind+1*volsz];
	oldtens[2]=in_tens[thisind+2*volsz];
	oldtens[3]=in_tens[thisind+3*volsz];
	oldtens[4]=in_tens[thisind+4*volsz];
	oldtens[5]=in_tens[thisind+5*volsz];
	/*	newtens=&out_tens[6*(y+x*ysz+z*zoffset)]; /* Args for computations */
/*
** Computations for each pixel
*/
	calc_eigval(oldtens,eigval);
/*
** Scale eigenvalues according to the map functions
**
** First compute the norm of the tensor
*/
	Tnorm = sqrt(eigval[0]*eigval[0]+eigval[1]*eigval[1]+
		     eigval[2]*eigval[2]);
/*
** Compute the new eigenvalues
*/
	gamma[0] = mmap(Tnorm,adm_sigma,adm_alpha,adm_beta,adm_j);
	my2 = mymap(eigval[1]/eigval[0],admy_alpha,admy_beta,admy_j);
	gamma[1]=gamma[0]*my2;
	my3 = mymap(eigval[2]/eigval[1],admy_alpha,admy_beta,admy_j);
	gamma[2]=gamma[1]*my3;
/*
** Re-map the tensor eigensystem
*/ 
	l1=eigval[0];l2=eigval[1];l3=eigval[2];
	g1=gamma[0];g2=gamma[1];g3=gamma[2];
/*
** delta=[(g1-g3)(l1-l2)-(g1-g2)(l1-l3)]/(l1-l3)/(l1-l2)/-(l2-l3)
*/
	delta=g3*l2-g3*l1-g1*l2-g2*l3+g2*l1+g1*l3;
	if(delta!=0.0)
	  delta /=l3*l2*l3-l3*l2*l2-l3*l1*l3+l1*l2*l2+l1*l1*l3-l1*l1*l2;
/*
** alpha = (g1-g2)/(l1-l2) - delta*(l1+l2)
*/
	alpha = (g1-g2-delta*l1*l1+delta*l2*l2)/(l1-l2);
/*
** beta = g1-l1*alpha - l1^2*delta
*/
	beta = g1-l1*alpha-l1*l1*delta;

	remap_tensor(newtens,oldtens,alpha,beta,delta);
/*
** Debugging
*/ 
	/*	if((x==3)&&(y==9)&&(z==5)) {
	  mexPrintf("Position x=%d y=%d z=%d\n",x,y,z);
	  mexPrintf("oldtens=[%g %g %g %g %g %g]\n",oldtens[0],oldtens[1],
		    oldtens[2],oldtens[3],oldtens[4],oldtens[5]);
	  mexPrintf("eigval=[%g %g %g]\n",eigval[0],eigval[1],eigval[2]);
	  mexPrintf("gamma=[%g %g %g]\n",gamma[0],gamma[1],gamma[2]);
	  mexPrintf("alpha=%g beta=%g delta=%g\n",alpha,beta,delta);
	  mexPrintf("newtens=[%g %g %g %g %g %g]\n",newtens[0],newtens[1],
		    newtens[2],newtens[3],newtens[4],newtens[5]);	  
	}*/
/*
** Store the results
*/
	thisind=y+x*ysz+z*zoffset;
	out_tens[thisind]=newtens[0];
	out_tens[thisind+1*outvolsz]=newtens[1];
	out_tens[thisind+2*outvolsz]=newtens[2];
	out_tens[thisind+3*outvolsz]=newtens[3];
	out_tens[thisind+4*outvolsz]=newtens[4];
	out_tens[thisind+5*outvolsz]=newtens[5];
      }
    }
  }
}
/*
** Function to check wether an argument is
** a double 4d matrix of given size
** -1 as size means any size
*/
int hasSize(const mxArray *arg,int *msize)
{
const int *dims;
int retval;
  dims = mxGetDimensions(arg);
  retval=1;
  if(mxGetClassID(arg) != mxDOUBLE_CLASS) retval=0;
  if(mxGetNumberOfDimensions(arg) != 4) retval=0;
  if((msize[0] != -1) && (dims[0] != msize[0])) retval=0;
  if((msize[1] != -1) && (dims[1] != msize[1])) retval=0;
  if((msize[2] != -1) && (dims[2] != msize[2])) retval=0;
  if((msize[3] != -1) && (dims[3] != msize[3])) retval=0;
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
int msize[4];
double *tensor,*result,*sl;
mxArray *mx_result;
int slice;
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
   if((nrhs != 1)&&(nrhs != 2)) {
     if(nrhs !=0) mexPrintf("Error: Wrong number of input arguments.\n");
     goto mexErrExit;
   }
   if(nrhs == 2) {
     if(mxGetNumberOfDimensions(prhs[1]) != 2) {
       mexErrMsgTxt("Type mismatch: The <slice> argument should be a scalar\n");
     }
     sl =(double *)mxGetPr(prhs[1]);
     slice = sl[0];
     if(slice<=0) mexErrMsgTxt("Error: The <slice> argument should be >0");
   } else {
     slice=-1;
   }
   msize[0]=msize[1]=msize[2]=-1;msize[3]=6;
   if(!hasSize(prhs[0],msize)) 
     mexErrMsgTxt("Type mismatch: The <T6> argument should be a mxnxox6 double matrix.\n");
/*
** Fetch the argument, and call the computation function
*/
   dims = mxGetDimensions(prhs[0]);
   if(slice != -1)
     if((slice<1)||(slice>dims[2])) {
       mexPrintf("Error: <slice> is not inside the volume.\n");
       goto mexErrExit;
     }
   msize[0]=dims[0];
   msize[1]=dims[1];
   msize[2]=dims[2];
   msize[3]=dims[3];
   if(slice != -1) msize[2]=1;
   mx_result = mxCreateNumericArray(4,msize,mxDOUBLE_CLASS,mxREAL);
   result=(double *)mxGetPr(mx_result);
   tensor = mxGetPr(prhs[0]);
   tensMap3D(tensor,result,dims[0],dims[1],dims[2],*adm_sigma,*adm_alpha,
		*adm_beta,*adm_j,*admy_alpha,*admy_beta,*admy_j,slice);
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
     mexPrintf("Usage: <T6> = tensMap3D(<T6>,[<slice>])\n");
mexExit: {}
}

