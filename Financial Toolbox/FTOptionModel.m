//
//  OptionModel.m
//  FinanceTest
//
//  Created by Richard Lewis on 5/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FTOptionModel.h"

@implementation FTOptionModel

@synthesize S,K,v,r,d,T,phi;
@dynamic b;

const double shift = 0.0001;

- (double) b
{
	return r-d;
}

- (BOOL) isCall
{
	return phi == call;
}

- (BOOL) isPut
{
	return phi == put;
}

- (id) initWithType: (FTOptionType) _type spot: (double)_S strike: (double)_K vol: (double) _sigma rate: (double)_r dividend: (double)_d expiry: (double)_T 
{
	[super init];
	
	phi = _type;
	S = _S;
	K = _K;
	r = _r;
	v = _sigma;
	d = _d;
	T = _T;
	
	return self;
}

-(double) price
{
	return 0.0;
}

-(double) dxdP: (double&)dx h:(const double)h
{
	double x = dx;
	
	dx = x + h;
	double Pup = [self price];
	
	dx = x - h;
	double Pdn = [self price];
	
	dx = x;
	
	return (Pup - Pdn) / (2 * h);	
}

-(double) dx2dP: (double&)dx h:(const double)h
{
	double x = dx;
	
	dx = x + h;
	double Pup = [self price];
	
	dx = x - h;
	double Pdn = [self price];
	
	dx = x;
	double P = [self price];
	
	return (Pup + Pdn - 2 * P) / (h * h);
}

-(double) delta
{
	return [self dxdP: S h: shift];
}

-(double) deltaK
{
	return [self dxdP: K h: shift];
}

- (double) elasticity
{
	return [self delta] * S / [self price];
}

-(double) gamma
{
	return [self dx2dP: S h: shift];
}

-(double) gammaK
{
	return [self dx2dP: K h: shift];
}

-(double) theta
{
	const double h = 1/365.0;

	if (T > h) {
		double pt = T;
		
		T = pt - h;
		
		double Pdn = [self price];
		
		T = pt;
		double P = [self price];
		
		return (Pdn - P) / h;
	}
	
	return 0.0;
}

-(double) rho
{
	return [self dxdP: r h: shift];
}

-(double) rho2
{
	return [self dxdP: d h: shift];
}

-(double) rhof
{
	const double h = shift;
	
	double pr = r;
	double pd = d;
	
	r = pr + h;
	d = pd + h;
	double Pup = [self price];
	
	r = pr - h;
	d = pd - h;
	double Pdn = [self price];
	
	r = pr;
	d = pd;
	
	return (Pup - Pdn) / (2 * h);	
}


-(double) vega
{
	return [self dxdP: v h: shift];
}


- (double) impliedVolFromPrice: (double) p epsilon: (double)eps
{
	double pv = v;
	
	//Manaster and Koehler seed value (vi)
    v = sqrt(fabs(log(S / K) + r * T) * 2 / T);

    double ci = [self price];

    double vegai = [self vega];
    double minDiff = fabs(p - ci);
    
    while (fabs(p - ci) >= eps && fabs(p - ci) <= minDiff) {
		v -= (ci - p) / vegai;
		ci = [self price];
		vegai = [self vega];
		minDiff = fabs(p - ci);
    }
	
	double vi = v;
	v = pv;
	
    return (fabs(p - ci) < eps) ? vi : 0.0;
	
}

@end
