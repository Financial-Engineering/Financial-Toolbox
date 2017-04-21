//
//  AsianTurnbullWakeman.h
//  Option Test
//
//  Created by Richard Lewis on 5/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTOptionModel.h"

@interface FTAsianTurnbullWakeman : FTOptionModel {
	double SA,T2;
}

@property double SA,T2;

- (id) initWithType: (FTOptionType) _type spot: (double)_S spotAvg: (double) _SA strike: (double)_K vol: (double) _sigma 
			   rate: (double)_r dividend: (double)_d expiry: (double)_T timeAvg: (double)T2;

- (double) price;

@end
