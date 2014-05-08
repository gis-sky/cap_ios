//
//  GeoCodeUtility.m
//  CapDocument
//
//  Created by snowdaily on 2014/3/19.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import "GeoCodeUtility.h"
#define PATH @""

@implementation GeoCodeUtility

+(NSString*)getPolygon:(NSString*)geocode Type:(NSString*)type
{
	//NSString *path = PATH;
	if([type isEqualToString:@"gml"])
	{
		return @"";
	}
	else if([type isEqualToString:@"kml"])
	{
		return @"";
	}
	
	return @"";
}

@end
