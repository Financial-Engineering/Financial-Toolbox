//
//  BlackScholes.m
//  Finance
//
//  Created by Richard Lewis on 5/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FTBlackScholes.h"
#import "FTDistributions.h"

@implementation FTBlackScholes

- (double) d1
{
	return (log(S/K) + (r - d + 0.5 * v * v) * T) / (v * sqrt(T));
}

- (double) d2
{
	return [self d1] - v * sqrt(T);
}

- (double) price
{
	return phi * (S * exp(-d*T) * [FTDistributions normal: phi * [self d1]] - K * exp(-r*T) * [FTDistributions normal: phi * [self d2]]);
}

- (double) delta
{
	return phi*[FTDistributions normal: phi*[self d1]];
}

- (double) deltaK
{
	return phi*[FTDistributions normal: phi*[self d2]];
}

- (double) gamma
{
	return [FTDistributions normalPdf:[self d1]]/(S*v*sqrt(T));
}

- (double) gammaK
{
	return [FTDistributions normalPdf:[self d2]]/(K*v*sqrt(T));
}

- (double) vega
{
	return S * [FTDistributions normalPdf:[self d1]] * T;
}

- (double) theta
{
	return -S * [FTDistributions normalPdf:[self d1]] * v / (2.0 * sqrt(T)) 
		   - phi * r * K * exp(-r * T) * phi * [FTDistributions normal: phi * [self d2]];
}

- (double) rho
{
	return phi * K * T * exp(-r * T) * [FTDistributions normal: phi * [self d2]];
}

@end
