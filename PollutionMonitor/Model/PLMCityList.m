//
//  AOBLesionList.m
//  Animal Observer
//
//  Created by Demian Turner on 23/09/2016.
//  Copyright © 2016 Gorilla Fund. All rights reserved.
//

#import "PLMCityList.h"


@implementation PLMCityList

+ (NSArray *)cities
{
    static NSArray *cities;
    if (!cities) {
        cities = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"]];
    }
    return cities;
}

+ (NSDictionary *)cityAtIndex:(NSInteger)index
{
    NSArray *cities = [self cities];
    return cities[index];
}

@end
