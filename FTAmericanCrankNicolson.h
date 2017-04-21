//
//  AmericanCrankNicolson.h
//  FinanceTest
//
//  Created by Richard Lewis on 5/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTOptionModel.h"

@interface FTAmericanCrankNicolson : FTOptionModel {
	unsigned N,M;
	
	double _price;
	double _delta;
	double _gamma;
	double _theta;
}

@property unsigned M,N;

- (id) initWithType: (FTOptionType) _type spot: (double)_S strike: (double)_K vol: (double) _sigma rate: (double)_r dividend: (double)_d 
		  expiry: (double)_T timeSteps: (unsigned)_N priceSteps: (unsigned) _M;

- (double) price;
- (double) delta;
- (double) gamma;

@end
