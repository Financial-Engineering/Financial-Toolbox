//
//  Random.m
//  Options
//
//  Created by Richard Lewis on 6/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FTRandom.h"
#import <math.h>

@implementation FTRandom


// generate uniform random deviates on [0,1)
+ (double) urand
{
	return random() / (RAND_MAX + 1.0);
}

// box-muller transform with polar rejection
+ (double) nrand
{
	static BOOL iset = NO;
	static double gset;
	
	double fac,rsq,v1,v2;
	
	if (!iset) {
		do {
			v1 = 2.0 * [self urand] - 1.0; // transform to (-1,1)
			v2 = 2.0 * [self urand] - 1.0;
			rsq = v1 * v1 + v2 * v2;
		} while (rsq >= 1.0 || rsq == 0.0);
		fac = sqrt(-2.0 * log(rsq) / rsq);
		gset = v1 * fac;
		iset = YES;
		return v2 * fac;
	}
	else {
		iset = NO;
		return gset;
	}
}

#define MAXBIT 30
#define MAXDIM 6

#ifndef min
#define min(x,y) (x)<(y)?(x):(y)
#endif

+(double*) sobol:(int)n
{
	const double fac = 1.0/(1L << MAXBIT);
	
	static unsigned long in,ix[MAXDIM],iu[MAXBIT][4];
	
	const unsigned long mdeg[MAXDIM]={1,2,3,3,4,4};
	const unsigned long ip[MAXDIM]={0,1,1,2,1,4};
	const unsigned long iv[MAXDIM*MAXBIT]={1,1,1,1,1,1,3,1,3,3,1,1,5,7,7,3,3,5,15,11,5,15,13,9};
	
	double* x = NULL;
	
	if (n < 0) { //Initialize, don't return a vector.
		for (int k=0;k<MAXDIM;k++) 
			ix[k]=0;
		in=0;
		if (iv[0] != 1) return x;
		//fac=1.0/(1L << MAXBIT);
		for (int j=0, k=0;j<MAXBIT;j++,k+=MAXDIM) 
			iu[j][0] = iv[k];
		for (int k=0;k<MAXDIM;k++) {
			for (int j=0;j<mdeg[k];j++) 
				iu[j][k] <<= (MAXBIT-j);
			for (unsigned long j=mdeg[k];j<MAXBIT;j++) { 
				unsigned long ipp = ip[k];
				unsigned long i = iu[j-mdeg[k]][k];
				i ^= (i >> mdeg[k]);
				for (unsigned long l=mdeg[k]-1;l>=1;l--) {
					if (ipp & 1) i ^= iu[j-l][k];
					ipp >>= 1;
				}
				iu[j][k]=i;
			}
		}
	} else { 
		unsigned long im=in++; 
		
		int j = 0;
		
		for (j=0;j<MAXBIT;j++) { 
			if (!(im & 1)) break;
			im >>= 1;
		}
		if (j >= MAXBIT) return x;
		x = (double*)malloc(sizeof(double)*MAXDIM);
		im=j*MAXDIM;
		int m = min(n,MAXDIM);
		for (int k=0; k<m; k++) { 
			ix[k] ^= iv[im+k];
			x[k]=ix[k] * fac;
		}
	}
	
	return x;
}

@end
