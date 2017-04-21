//
//  OptionModel.h
//  FinanceTest
//
//  Created by Richard Lewis on 5/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#ifndef max
#define max(x,y) (x)>(y)?(x):(y)
#endif

#ifndef min
#define min(x,y) (x)<(y)?(x):(y)
#endif

typedef enum {
	put = -1,
	call = 1
} FTOptionType;

@interface FTOptionModel : NSObject {
	
	FTOptionType phi;
	
	double S,K,v,r,d,b,T;
}

@property double S,K,v,r,d,T;
@property (readonly) double b;
@property FTOptionType phi;

- (BOOL) isCall;
- (BOOL) isPut;

- (id) initWithType: (FTOptionType) _type spot: (double)_S strike: (double)_K vol: (double) _sigma rate: (double)_r dividend: (double)_d expiry: (double)_T;

- (double) price;

// numerical greeks
- (double) delta;
- (double) deltaK;
- (double) elasticity;
- (double) gamma;
- (double) gammaK;
- (double) vega;
- (double) theta;
- (double) rho;
- (double) rho2;
- (double) rhof;

// implied vol
- (double) impliedVolFromPrice: (double) p epsilon: (double)eps; 

@end
