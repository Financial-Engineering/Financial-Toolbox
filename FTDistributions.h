//
//  Distributions.h
//  Finance
//
//  Created by Richard Lewis on 5/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTDistributions : NSObject {
}

+ (double) normal:(double)x;
+ (double) bivariate:(double) x y: (double) y rho: (double) rho;

+ (double) normalPdf:(double)x withMean:(double)mean withStd: (double)std;
+ (double) normalPdf:(double)x;
@end
