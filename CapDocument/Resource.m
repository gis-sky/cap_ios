//
//  Resource.m
//  CapDocument
//
//  Created by snowdaily on 2014/3/19.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import "Resource.h"

@implementation Resource

-(id)initWithResourceDesc:(NSString*)resourceDesc
{
	if(self = [super init])
	{
		self.resourceDesc = resourceDesc;
	}
	return self;
}

@end
