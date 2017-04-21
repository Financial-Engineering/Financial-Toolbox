//
//  AsianDiscreteHHM.h
//  Options
//
//  Created by Richard Lewis on 5/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTOptionModel.h"

@interface FTAsianDiscreteHHM : FTOptionModel {
	double SA,t1;
	unsigned m,n;
}

@property double SA,t1;
@property unsigned m,n;

- (id) initWithType: (FTOptionType) _type spot: (double)_S spotAvg: (double) _SA strike: (double)_K vol: (double) _sigma 
			   rate: (double)_r dividend: (double)_d expiry: (double)_T timeAvg: (double)_t1 fixings: (unsigned) _n fixed: (unsigned) _m;

- (double) price;
@end
