//
//  Info.h
//  CapDocument
//
//  Created by snowdaily on 2014/3/19.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import <Foundation/Foundation.h>

enum InfoProp : NSInteger
{
	LANGUAGE,
	CATEGORY,
	EVENT,
	RESPONSETYPE,
	URGENCY,
	SEVERITY,
	CERTAINTY,
	AUDIENCE,
	EVENTCODE,
	EFFECTIVE,
	ONSET,
	EXPIRES,
	SENDERNAME,
	HEADLINE,
	DESCRIPTION,
	INSTRUCTION,
	WEB,
	CONTACT,
	PARAMETER,
	RESOURCE,
	AREA
};

@interface Info : NSObject

@property(strong, nonatomic)	NSString		*language;
@property(strong, nonatomic)	NSMutableArray	*category;		// NSString
@property(strong, nonatomic)	NSString		*event;
@property(strong, nonatomic)	NSMutableArray	*responseType;	// NSString
@property(strong, nonatomic)	NSString		*urgency;
@property(strong, nonatomic)	NSString		*severity;
@property(strong, nonatomic)	NSString		*certainty;
@property(strong, nonatomic)	NSString		*audience;
@property(strong, nonatomic)	NSMutableArray	*eventCode;		// EventCode
@property(strong, nonatomic)	NSString		*effective;
@property(strong, nonatomic)	NSString		*onset;
@property(strong, nonatomic)	NSString		*expires;
@property(strong, nonatomic)	NSString		*senderName;
@property(strong, nonatomic)	NSString		*headline;
@property(strong, nonatomic)	NSString		*description;
@property(strong, nonatomic)	NSString		*instruction;
@property(strong, nonatomic)	NSString		*web;
@property(strong, nonatomic)	NSString		*contact;
@property(strong, nonatomic)	NSMutableArray	*parameter;		// Parameter
@property(strong, nonatomic)	NSMutableArray	*resource;		// Resource
@property(strong, nonatomic)	NSMutableArray	*area;			// Area

-(void)setValue:(enum InfoProp)prop Value:(NSString*)value;
-(NSString*)getValue:(enum InfoProp)prop;

@end
