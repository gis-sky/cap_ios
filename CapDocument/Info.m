//
//  Info.m
//  CapDocument
//
//  Created by snowdaily on 2014/3/19.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import "Info.h"

@implementation Info

-(id)init
{
	if(self = [super init])
	{
		self.responseType = [NSMutableArray new];
		self.eventCode = [NSMutableArray new];
		self.parameter = [NSMutableArray new];
		self.resource = [NSMutableArray new];
		self.area = [NSMutableArray new];
	}
	return self;
}

-(void)setValue:(enum InfoProp)prop Value:(NSString*)value
{
	switch (prop)
	{
		case LANGUAGE:
			self.language = value;
			break;
		case EVENT:
			self.event = value;
			break;
		case URGENCY:
			self.urgency = value;
			break;
		case SEVERITY:
			self.severity = value;
			break;
		case CERTAINTY:
			self.certainty = value;
			break;
		case AUDIENCE:
			self.audience = value;
			break;
		case EFFECTIVE:
			self.effective = value;
			break;
		case ONSET:
			self.onset = value;
			break;
		case EXPIRES:
			self.expires = value;
			break;
		case SENDERNAME:
			self.senderName = value;
			break;
		case HEADLINE:
			self.headline = value;
			break;
		case DESCRIPTION:
			self.description = value;
			break;
		case INSTRUCTION:
			self.instruction = value;
			break;
		case WEB:
			self.web = value;
			break;
		case CONTACT:
			self.contact = value;
			break;
	}
}

-(NSString*)getValue:(enum InfoProp)prop
{
	switch (prop)
	{
		case LANGUAGE:
			return self.language;
		case EVENT:
			return self.event;
		case URGENCY:
			return self.urgency;
		case SEVERITY:
			return self.severity;
		case CERTAINTY:
			return self.certainty;
		case AUDIENCE:
			return self.audience;
		case EFFECTIVE:
			return self.effective;
		case ONSET:
			return self.onset;
		case EXPIRES:
			return self.expires;
		case SENDERNAME:
			return self.senderName;
		case HEADLINE:
			return self.headline;
		case DESCRIPTION:
			return self.description;
		case INSTRUCTION:
			return self.instruction;
		case WEB:
			return self.web;
		case CONTACT:
			return self.contact;
		default:
			return @"";
	}
}

@end
