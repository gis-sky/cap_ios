//
//  CapValidateResult.m
//  CapDocument
//
//  Created by snowdaily on 2014/3/17.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import "CapValidateResult.h"

@implementation CapValidateResult
@synthesize subject,message;

-(id)initWithSubject:(NSString*)aSubject Message:(NSString*)aMessage
{
	if(self = [super init])
	{
		subject = [aSubject copy];
		message = [aMessage copy];
	}

	return self;
}

@end
