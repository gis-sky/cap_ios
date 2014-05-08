//
//  Area.h
//  CapDocument
//
//  Created by snowdaily on 2014/3/19.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Area : NSObject

@property(strong, nonatomic)	NSString		*areaDesc;
@property(strong, nonatomic)	NSMutableArray	*polygon;	// NSString
@property(strong, nonatomic)	NSMutableArray	*circle;	// NSString
@property(strong, nonatomic)	NSMutableArray	*geocode;	// GeoCode
@property(assign, nonatomic)	NSInteger		 altitude;
@property(assign, nonatomic)	NSInteger		 ceiling;

-(id)initWithAreaDesc:(NSString*)areaDesc;

@end
