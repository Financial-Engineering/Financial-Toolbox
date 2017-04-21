//
//  Financial_ToolboxTests.m
//  Financial ToolboxTests
//
//  Created by Richard Lewis on 3/13/11.
//  Copyright 2011 RRT. All rights reserved.
//

#import "Financial_ToolboxTests.h"
#import "FTBlackScholes.h"

@implementation Financial_ToolboxTests

FTBlackScholes* bs;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
     bs = [[FTBlackScholes alloc] initWithType:call spot:100 strike:100 vol:.2 rate:.05 dividend:0 expiry:.5];

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    double p = [bs price];
    double d = [bs delta];
    double v = [bs vega];
    double t = [bs theta];
}

@end
