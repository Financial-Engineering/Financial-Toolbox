//
//  AmericanCrankNicolson.m
//  FinanceTest
//
//  Created by Richard Lewis on 5/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FTAmericanCrankNicolson.h"

@implementation FTAmericanCrankNicolson

@synthesize N,M;

- (id) initWithType: (FTOptionType) _type spot: (double)_S strike: (double)_K vol: (double) _sigma rate: (double)_r dividend: (double)_d expiry: (double)_T
		  timeSteps: (unsigned)_N priceSteps: (unsigned) _M
{
	[super initWithType:_type spot:_S strike:_K vol:_sigma rate:_r dividend:_d expiry:_T];
	
	N = _N;
	M = _M;
	
	return self;	
}


-(double)price
{

	double C[M/2+1][M+1];
	double p[M];
	double pmd[M];
	double St[M-1];
	
    double dt = T / N;
    double dx = v * sqrt(3 * dt);
	
	double sq = v * v;
	double vdx2 = sq / (dx * dx);

	b = r-d;
    double pu = -0.25 * dt * (vdx2 + (b - 0.5 * sq) / dx);
    double pm = 1 + 0.5 * dt * vdx2 + 0.5 * r * dt;
    double pd = -0.25 * dt * (vdx2 - (b - 0.5 * sq) / dx);
	
	St[0] = S * exp(-(M/2.0)*dx);
	C[0][0] = max(0, phi * (St[0] - K));
	
	for(int i=1; i<=M; i++) 
	{
		St[i] = St[i-1] * exp(dx);
		C[0][i] = max(0, phi * (St[i] - K));
		
	}
	
	pmd[1] = pm + pd;
	p[1] = -pu * C[0][2] - (pm - 2) * C[0][1] - pd * C[0][0] - pd * (St[1] - St[0]);
	
	for(int j = N - 1; j>=0; j--)
	{
		for(int i = 2; i<M; i++)
		{
			p[i] = -pu * C[0][i+1] - (pm - 2) * C[0][i] - pd * C[0][i-1] - p[i-1] * pd / pmd[i-1];
			pmd[i] = pm - pu * pd / pmd[i-1];
		}
		
		for(int i = M - 2; i>=1; i--)
		{
			C[1][i] = (p[i] - pu * C[1][i+1])/pmd[i];
		}
		
		for(int i=0; i<=M; i++)
		{
			C[0][i] = C[1][i];
			C[0][i] = max(C[1][i], phi * (St[i] - K));
		}
	}
	
	unsigned j = M/2;
	
	_delta = (C[0][j+1] - C[0][j-1]) / (St[j+1] - St[j-1]);
	_gamma = ((C[0][j+1] - C[0][j]) / (St[j+1] - St[j]) - (C[0][j] - C[0][j-1]) / (St[j] - St[j-1])) / (0.5 * (St[j+1]-St[j-1]));
	_price = C[0][j];
	
	return _price;
	
}

-(double) delta
{
	return _delta;
}


-(double) gamma
{
	return _gamma;
}


@end
