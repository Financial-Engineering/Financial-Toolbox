//
//  BlackScholes.h
//  Finance
//
//  Created by Richard Lewis on 5/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTOptionModel.h"

@interface FTBlackScholes :FTOptionModel {
}

- (double) price;

// analytical greeks
- (double) delta;
- (double) deltaK;
- (double) gamma;
- (double) gammaK;
- (double) vega;
- (double) theta;
- (double) rho;

@end
