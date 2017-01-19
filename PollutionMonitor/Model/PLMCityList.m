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

+ (NSDictionary *)dictionary
{
    static NSDictionary *cities;
    if (!cities) {
        NSMutableDictionary *tmpCities = [[NSMutableDictionary alloc] init];
        NSArray *citiesArray = [self cities];
        for (NSDictionary *cityDict in citiesArray) {
            [cityDict enumerateKeysAndObjectsUsingBlock:^(NSString *cityName, NSValue *cityCode, BOOL *stop) {
                [tmpCities setObject:cityName forKey:cityCode];
            }];
        }
        cities = [tmpCities copy];
    }
    return cities;
}

+ (NSDictionary *)cityAtIndex:(NSInteger)index
{
    NSArray *cities = [self cities];
    return cities[index];
}

@end
