//
//  Random.h
//  Options
//
//  Created by Richard Lewis on 6/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTRandom : NSObject {

}

+ (double) urand;
+ (double) nrand;

+ (double*) sobol:(int)n;

@end
