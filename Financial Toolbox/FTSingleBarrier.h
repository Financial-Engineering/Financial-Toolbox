//
//  FTSingleBarrier.h
//  Options
//
//  Created by Richard Lewis on 6/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTOptionModel.h"

typedef enum {
	in = 0x1,
	out = 0x2,
	down = 0x4,
	up = 0x8
} FTBarrierType;

@interface FTSingleBarrier : FTOptionModel {
	double H;
	double rebate;
	
	FTBarrierType barrierType;
}

@property double H;
@property double rebate;
@property FTBarrierType barrierType;

- (BOOL) isDown;
- (BOOL) isUp;
- (BOOL) isOut;
- (BOOL) isIn;
- (BOOL) isDownAndOut;
- (BOOL) isDownAndIn;
- (BOOL) isUpAndOut;
- (BOOL) isUpAndIn;

- (id) initWithType: (FTOptionType) _type barrierType: (FTBarrierType) _barrierType 
			   spot: (double)_S strike: (double)_K barrier: (double)_H 
				vol: (double) _sigma rate: (double)_r dividend: (double)_d expiry: (double)_T
			 rebate: (double) _rebate;

- (double) price;

@end
