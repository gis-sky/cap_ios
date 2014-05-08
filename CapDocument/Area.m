//
//  Area.m
//  CapDocument
//
//  Created by snowdaily on 2014/3/19.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import "Area.h"

@implementation Area

-(id)initWithAreaDesc:(NSString*)areaDesc
{
	if(self = [super init])
	{
		self.areaDesc = areaDesc;
	}
	return self;
}

@end
