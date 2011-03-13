//
//  FTSingleBarrier.m
//  Options
//
//  Created by Richard Lewis on 6/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FTSingleBarrier.h"
#import "FTDistributions.h"
#import "FTBlackScholes.h"

#define CND(x) [FTDistributions normal: (x)]

@implementation FTSingleBarrier

@synthesize H,barrierType,rebate;

- (BOOL) isDown
{
	return barrierType & down;
}

- (BOOL) isUp
{
	return barrierType & up;
}

- (BOOL) isOut 
{
	return barrierType & out;
}

- (BOOL) isIn
{
	return barrierType & in;
}

- (BOOL) isDownAndOut
{
	return barrierType == (down|out);
}

- (BOOL) isDownAndIn
{
	return barrierType == (down|in);
}

- (BOOL) isUpAndOut
{
	return barrierType == (up|out);
}

- (BOOL) isUpAndIn
{
	return barrierType == (up|in);
}

- (BOOL) isOutsideBarrier
{
	return ([self isDown] && (S <= H)) || ([self isUp] && (S >= H));
}

- (id) initWithType: (FTOptionType) _type barrierType: (FTBarrierType) _barrierType 
			   spot: (double)_S strike: (double)_K barrier: (double)_H 
				vol: (double) _sigma rate: (double)_r dividend: (double)_d expiry: (double)_T
			 rebate: (double) _rebate
{
	[super initWithType:_type spot:_S strike:_K vol:_sigma rate:_r dividend:_d expiry:_T];
	
	H = _H;
	barrierType = _barrierType;
	rebate = _rebate;
	
	return self;	
}

- (double) price
{
	if ([self isOutsideBarrier])
	{
		if ([self isOut])
			return ([self isPut]) ? K : 0;
		else {
			id opt = [[FTBlackScholes alloc] initWithType:phi spot:S strike:K vol:v rate:r dividend:d expiry:T];
			double p = [opt price];
			[opt release];
			return p;
		}
	}
	
	double eta = [self isUp] ? -1 : 1;
	
	double mu = ((r - d) - (v * v) / 2) / (v * v);
    double lambda = sqrt((mu * mu) + 2 * r / (v * v));
    double X1 = log(S / K) / (v * sqrt(T)) + (1 + mu) * v * sqrt(T);
    double X2 = log(S / H) / (v * sqrt(T)) + (1 + mu) * v * sqrt(T);
    double y1 = log((H * H) / (S * K)) / (v * sqrt(T)) + (1 + mu) * v * sqrt(T);
    double y2 = log(H / S) / (v * sqrt(T)) + (1 + mu) * v * sqrt(T);
    double z = log(H / S) / (v * sqrt(T)) + lambda * v * sqrt(T);

	double f1 = phi * S * exp(-d * T) * CND(phi * X1) - phi * K * exp(-r * T) * CND(phi * X1 - phi * v * sqrt(T));
    double f2 = phi * S * exp(-d * T) * CND(phi * X2) - phi * K * exp(-r * T) * CND(phi * X2 - phi * v * sqrt(T));
    double f3 = phi * S * exp(-d * T) * pow((H / S),(2 * (mu + 1))) * CND(eta * y1) - phi * K * exp(-r * T) * pow((H / S),(2 * mu)) * CND(eta * y1 - eta * v * sqrt(T));
    double f4 = phi * S * exp(-d * T) * pow((H / S),(2 * (mu + 1))) * CND(eta * y2) - phi * K * exp(-r * T) * pow((H / S),(2 * mu)) * CND(eta * y2 - eta * v * sqrt(T));
    double f5 = rebate * exp(-r * T) * (CND(eta * X2 - eta * v * sqrt(T)) - pow((H / S),(2 * mu)) * CND(eta * y2 - eta * v * sqrt(T)));
    double f6 = rebate * (pow((H / S),(mu + lambda)) * CND(eta * z) + pow((H / S),(mu - lambda)) * CND(eta * z - 2 * eta * lambda * v * sqrt(T)));
	
	if (K > H)
	{
		if (([self isCall]) && [self isDownAndIn])
			return f3 + f5;
		if (([self isCall]) && [self isUpAndIn])
			return f1 + f5;
		if (([self isPut]) && [self isDownAndIn])
			return f2 - f3 + f4 + f5;
		if (([self isPut]) && [self isUpAndIn])
			return f1 - f2 + f4 + f5;
		if (([self isCall]) && [self isDownAndOut])
			return f1 - f3 + f6;
		if (([self isCall]) && [self isUpAndOut])
			return f6;
		if (([self isPut]) && [self isDownAndOut])
			return f1 - f2 + f3 - f4 + f6;
		if (([self isPut]) && [self isUpAndOut])
			return f2 - f4 + f6;		
	}
	else if (K < H)
	{
		if (([self isCall]) && [self isDownAndIn])
			return f1 - f2 + f4 + f5;
		if (([self isCall]) && [self isUpAndIn])
			return f2 - f3 + f4 + f5;
		if (([self isPut]) && [self isDownAndIn])
			return f1 + f5;
		if (([self isPut]) && [self isUpAndIn])
			return f3 + f5;
		if (([self isCall]) && [self isDownAndOut])
			return f2 + f6 - f4;
		if (([self isCall]) && [self isUpAndOut])
			return f1 - f2 + f3 - f4 + f6;
		if (([self isPut]) && [self isDownAndOut])
			return f6;
		if (([self isPut]) && [self isUpAndOut])
			return f1 - f3 + f6;				
	}
	
	return 0.0;
}


@end
