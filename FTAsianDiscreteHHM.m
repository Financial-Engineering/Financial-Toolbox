//
//  AsianDiscreteHHM.m
//  Options
//
//  Created by Richard Lewis on 5/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FTAsianDiscreteHHM.h"
#import "FTDistributions.h"
#import "FTBlackScholes.h"

@implementation FTAsianDiscreteHHM

@synthesize SA,t1,m,n;

- (id) initWithType: (FTOptionType) _type spot: (double)_S spotAvg: (double) _SA strike: (double)_K vol: (double) _sigma 
			   rate: (double)_r dividend: (double)_d expiry: (double)_T timeAvg: (double)_t1 fixings: (unsigned) _n fixed: (unsigned) _m
{
	[super initWithType:_type spot:_S strike:_K vol:_sigma rate:_r dividend:_d expiry:_T];
	
	SA = _SA;
	t1 = _t1;
	m = _m;
	n = _n;
	
	return self;	
}

-(double)price
{
	double h = (T - t1) / (n - 1);
	double X = K;
	
	double EA = (b == 0) ? S : S / n * exp(b * t1) * (1 - exp(b * h * n)) / (1 - exp(b * h));
	
	if (m > 0) {
		if (SA > n / m * X) {   // Exercise is certain for call, put must be out-of-the-money
			if (phi == call) {
				SA = SA * m / n + EA * (n - m) / n;
				return (SA - X) * exp(-r * T);
			}
			return 0.0;
		}
    }
	
	if (m == (n - 1)) { // Only one fix left use Black-Scholes weighted with time
		
		X = n * X - (n - 1) * SA;
		FTOptionModel *opt = [[FTBlackScholes alloc] initWithType:put spot:S strike:X vol:v rate:r dividend:d expiry:T];
		double bs = [opt price];
		[opt release];
		return bs * 1 / n;
	}
	
	double EA2 = 0.0;
	
    if (b == 0)
		EA2 = S * S * exp(v * v * t1) / (n * n) * ((1 - exp(v * v * h * n)) / (1 - exp(v * v * h)) +
												   2 / (1 - exp(v * v * h)) * (n - (1 - exp(v * v * h * n)) / (1 - exp(v * v * h))));
    else    
		EA2 = S * S * exp((2 * b + v * v) * t1) / (n * n) * ((1 - exp((2 * b + v * v) * h * n)) / (1 - exp((2 * b + v * v) * h)) +
															 2 / (1 - exp((b + v * v) * h)) * ((1 - exp(b * h * n)) / (1 - exp(b * h)) - 
																							   (1 - exp((2 * b + v * v) * h * n)) / (1 - exp((2 * b + v * v) * h))));
	
    double vA = sqrt((log(EA2) - 2 * log(EA)) / T);
    
    if (m > 0)
		X = n / (n - m) * X - m / (n - m) * SA;
    
    double d1 = (log(EA / X) + (vA * vA) / 2 * T) / (vA * sqrt(T));
    double d2 = d1 - vA * sqrt(T);
	
	
	double optionValue = (phi == call) ? exp(-r * T) * (EA * [FTDistributions normal: d1] - X * [FTDistributions normal: d2]) 
	: exp(-r * T) * (X * [FTDistributions normal: -d2] - EA * [FTDistributions normal: -d1]);
	
	return optionValue * (n - m) / n;
}

@end
