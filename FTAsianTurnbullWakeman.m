//
//  FTAsianTurnbullWakeman.m
//  Option Test
//
//  Created by Richard Lewis on 5/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FTAsianTurnbullWakeman.h"
#import "FTBlackScholes.h"

@implementation FTAsianTurnbullWakeman

@synthesize SA,T2;

- (id) initWithType: (FTOptionType) _type spot: (double)_S spotAvg: (double) _SA strike: (double)_K vol: (double) _sigma 
			   rate: (double)_r dividend: (double)_d expiry: (double)_T timeAvg: (double)_T2
{
	[super initWithType:_type spot:_S strike:_K vol:_sigma rate:_r dividend:_d expiry:_T];
	
	SA = _SA;
	T2 = _T2;
	
	return self;	
}

-(double)price
{
	double t1 = fmax(0, T - T2);
	double tau = T2 - T;
	//double b = r - d;
	double M1 = (b == 0) ? 1 : (exp(b * T) - exp(b * t1)) / (b * (T - t1));
	
	//Take into account when option will be exercised
	if (tau > 0) {
		
		if (T2 / T * K - tau / T * SA < 0) {
			
			if ([self isCall]) {
				SA = SA * (T2 - T) / T2 + S * M1 * T / T2;  //Expected average at maturity
				return fmax(0, SA - K) * exp(-r * T);
			}
			else
				return 0.0;
		}
	}
	
	double dts = (T - t1) * (T - t1);
	
	double M2;
	if (b == 0)   //   Extended to hold for options on futures 16 May 1999 Espen Haug
		M2 = 2 * exp(v * v * T) / (pow(v,4) * dts) - 2 * exp(v * v * t1) * (1 + v * v * (T - t1)) / (pow(v,4) * dts);
	else
		M2 = 2 * exp((2 * b + v * v) * T) / ((b + v * v) * (2 * b + v * v) * dts) + 
		2 * exp((2 * b + v * v) * t1) / (b * dts) * (1 / (2 * b + v * v) - exp(b * (T - t1)) / (b + v * v));
	
	double bA = log(M1) / T;
	double vA = sqrt(log(M2) / T - 2 * bA);
	
	FTOptionType cp = [self isCall] ? call : put;
	FTOptionModel *opt1 = [[FTBlackScholes alloc] initWithType:cp spot:S strike:K vol:vA rate: r dividend: (r-bA) expiry: T];
	
	double td = 1;
	
	if (tau > 0) {
		opt1.K = T2 / T * K - tau / T * SA;
		td =  T / T2;
	}
	
	return [opt1 price] * td;	
}

@end
