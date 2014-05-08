//
//  CapValidator.m
//  CapDocument
//
//  Created by snowdaily on 2014/3/18.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#ifndef ALERT
	#define ALERT @"alert"
#endif

#ifndef INFO
	#define INFO @"info"
#endif

static NSArray *ALERT_TAGS = nil;
static NSArray *INFO_TAGS = nil;
static NSArray *INFO_OPTION_TAGS = nil;
static NSDictionary *INFO_REGEX_DIC = nil;
static NSDictionary *INFO_VALID_DIC = nil;
static NSArray *STATUS = nil;
static NSArray *MSG_TYPE = nil;
static NSArray *SCOPE = nil;

#import "CapValidator.h"
#import "CapValidateResult.h"

@implementation CapValidator

+(NSArray*) ALERT_TAGS
{
	if(nil == ALERT_TAGS)
	{
		ALERT_TAGS = @[
					   @"identifier",
					   @"sender",
					   @"sent",
					   @"status",
					   @"msgType",
					   @"scope"
					   ];
	}
	return ALERT_TAGS;
}

+(NSArray*) INFO_TAGS
{
	if(nil == INFO_TAGS)
	{
		INFO_TAGS = @[
					  @"language",
					  @"category",
					  @"event",
					  @"responseType",
					  @"urgency",
					  @"severity",
					  @"certainty",
					  @"audience",
					  @"eventCode",
					  @"effective",
					  @"onset",
					  @"expires",
					  @"senderName",
					  @"headline",
					  @"description",
					  @"instruction",
					  @"web",
					  @"contact",
					  @"parameter",
					  @"resource",
					  @"area"
					  ];
	}
	return INFO_TAGS;
}

+(NSArray*) INFO_OPTION_TAGS
{
	if(nil == INFO_OPTION_TAGS)
	{
		INFO_OPTION_TAGS = @[
							 @"language",
							 @"responseType",
							 @"audience",
							 @"eventCode",
							 @"effective",
							 @"onset",
							 @"expires",
							 @"senderName",
							 @"headline",
							 @"description",
							 @"instruction",
							 @"web",
							 @"contact",
							 @"parameter",
							 @"resource",
							 @"area"
							 ];
	}
	
	return INFO_OPTION_TAGS;
}

+(NSDictionary*) INFO_REGEX_DIC
{
	if(nil == INFO_REGEX_DIC)
	{
		INFO_REGEX_DIC =
			[[NSDictionary alloc] initWithObjectsAndKeys:
				[[NSRegularExpression alloc] initWithPattern:@"\\d\\d\\d\\d-\\d\\d-\\d\\dT\\d\\d:\\d\\d:\\d\\d[-,+]\\d\\d:\\d\\d"
													 options:NSRegularExpressionCaseInsensitive
													   error:NULL], @"effective",
				[[NSRegularExpression alloc] initWithPattern:@"\\d\\d\\d\\d-\\d\\d-\\d\\dT\\d\\d:\\d\\d:\\d\\d[-,+]\\d\\d:\\d\\d"
												  options:NSRegularExpressionCaseInsensitive
													error:NULL], @"onset",
				[[NSRegularExpression alloc] initWithPattern:@"\\d\\d\\d\\d-\\d\\d-\\d\\dT\\d\\d:\\d\\d:\\d\\d[-,+]\\d\\d:\\d\\d"
												  options:NSRegularExpressionCaseInsensitive
													error:NULL], @"expires",
				nil];
	}
	
	return INFO_REGEX_DIC;
}

+(NSDictionary*) INFO_VALID_DIC
{
	if(nil == INFO_VALID_DIC)
	{
		INFO_VALID_DIC =
			[[NSDictionary alloc] initWithObjectsAndKeys:
				@[
				  @"Geo",
				  @"Met",
				  @"Safety",
				  @"Security",
				  @"Rescue",
				  @"Fire",
				  @"Health",
				  @"Env",
				  @"Transport",
				  @"Infra",
				  @"CBRNE",
				  @"Other"
				],				@"category",
				@[
				  @"Shelter",
				  @"Evacuate",
				  @"Prepare",
				  @"Execute",
				  @"Avoid",
				  @"Monitor",
				  @"Assess",
				  @"AllClear",
				  @"None"
				],				@"responseType",
				@[
				  @"Immediate",
				  @"Expected",
				  @"Future",
				  @"Past",
				  @"Unknown"
				],				@"urgency",
				@[
				  @"Extreme",
				  @"Severe",
				  @"Moderate",
				  @"Minor",
				  @"Unknown"
				],				@"severity",
				@[
				  @"Observed",
				  @"Likely",
				  @"Possible",
				  @"Unlikely",
				  @"Unknown"
				],				@"certainty",
			 nil];
	}
	
	return INFO_VALID_DIC;
}

+(NSArray*) STATUS
{
	if(nil == STATUS)
	{
		STATUS = @[
				   @"Actual",
				   @"Exercise",
				   @"System",
				   @"Test",
				   @"Draft"
				   ];
	}
	return STATUS;
}

+(NSArray*) MSG_TYPE
{
	if(nil == MSG_TYPE)
	{
		MSG_TYPE = @[
					 @"Alert",
					 @"Update",
					 @"Cancel",
					 @"Ack",
					 @"Error"
					 ];
	}
	return MSG_TYPE;
}

+(NSArray*) SCOPE
{
	if(nil == SCOPE)
	{
		SCOPE = @[
				  @"Public",
				  @"Restricted",
				  @"Private"
				  ];
	}
	return SCOPE;
}

+(BOOL)ContainsString:(NSArray*)aArray Target:(NSString*)aTarget
{
	__block BOOL foundFlag = NO;
	[aArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if([(NSString*)obj isEqualToString:aTarget])
		{
			foundFlag = YES;
			*stop = YES;
		}
	}];
	
	return foundFlag;
}

+(BOOL)CapValidateResultsContainsSunject:(NSArray*)aArray Subject:(NSString*)aSubject
{
	__block BOOL foundFlag = NO;
	[aArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if([[(CapValidateResult*)obj subject] isEqualToString:aSubject]) {
			*stop = YES;
			foundFlag = YES;
		}
	}];
	return foundFlag;
}

+(BOOL)DictionaryContainsKey:(NSDictionary*)aDictionary Key:(NSString*)aKey
{
	__block BOOL foundFlag = NO;
	[aDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if([(NSString*)key isEqualToString:aKey])
		{
			*stop = YES;
			foundFlag = YES;
		}
	}];
	
	return foundFlag;
}

+(NSArray*)Validate:(xmlDocPtr)xDocument
{
	NSMutableArray *capValidateResults = [NSMutableArray new];
	xmlNodePtr rootNode = nil;
	
	if(nil == xDocument)
	{
		[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:ALERT
																		 Message:[NSString stringWithFormat:@"根節點必須是%@",ALERT]]];
	}
	else
	{
		rootNode = xmlDocGetRootElement(xDocument);
		
		if(![[NSString stringWithCString:((char*)rootNode -> name) encoding:NSUTF8StringEncoding] caseInsensitiveCompare:ALERT])
		{
			[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:ALERT
																			 Message:[NSString stringWithFormat:@"根節點必須是%@",ALERT]]];
		}
	}
	
	for (NSString *name in ALERT_TAGS)
	{
		if(YES == [self CapValidateResultsContainsSunject:capValidateResults Subject:name])
			continue;
		
		xmlNodePtr tag = NULL;
		for(xmlNodePtr node = rootNode -> children;node; node = node ->next)
		{
			if(NULL != node)
			{
				if([[NSString stringWithCString:((char*)node -> name) encoding:NSUTF8StringEncoding] isEqualToString:name])
				{
					tag = node;
					break;
				}
			}
		}
		if(NULL == tag)
		{
			[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																			 Message:[NSString stringWithFormat:@"必須有%@節點.",name]]];
			continue;
		}
		
		NSString *tagValue = [NSString stringWithCString:(char*)tag ->content encoding:NSUTF8StringEncoding];
		if([name isEqualToString:@"sent"])
		{
			NSRegularExpression *regex =
				[[NSRegularExpression alloc] initWithPattern:@"\\d\\d\\d\\d-\\d\\d-\\d\\dT\\d\\d:\\d\\d:\\d\\d[-,+]\\d\\d:\\d\\d"
													 options:NSRegularExpressionCaseInsensitive
													   error:NULL];
			if(0 == [regex numberOfMatchesInString:tagValue
										   options:NSMatchingReportProgress
											 range:NSRangeFromString(tagValue)])
			{
				[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																				 Message:[NSString stringWithFormat:@"%@節點資料格式錯誤.",name]]];
			}
		}
		else if([name isEqualToString:@"status"])
		{
			if(NO == [self ContainsString:STATUS Target:tagValue])
			{
				[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																				 Message:[NSString stringWithFormat:@"%@節點資料格式錯誤.",name]]];
			}
		}
		else if([name isEqualToString:@"msgType"])
		{
			if(NO == [self ContainsString:MSG_TYPE Target:tagValue])
			{
				[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																				 Message:[NSString stringWithFormat:@"%@節點資料格式錯誤.",name]]];
			}
		}
		else if([name isEqualToString:@"scope"])
		{
			if(NO == [self ContainsString:SCOPE Target:tagValue])
			{
				[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																				 Message:[NSString stringWithFormat:@"%@節點資料格式錯誤.",name]]];
			}
		}
	}
	
	for(xmlNodePtr info = rootNode -> children;info; info = info ->next)
	{
		if(NULL != info)
		{
			if([[NSString stringWithCString:((char*)info -> name) encoding:NSUTF8StringEncoding] isEqualToString:INFO])
			{
				for (NSString *name in INFO_TAGS)
				{
					if(YES == [self CapValidateResultsContainsSunject:capValidateResults Subject:name])
						continue;
					
					xmlNodePtr tag = NULL;
					for(xmlNodePtr node = info -> children;node; node = node ->next)
					{
						if(NULL != node)
						{
							if([[NSString stringWithCString:((char*)node -> name) encoding:NSUTF8StringEncoding] isEqualToString:name])
							{
								tag = node;
								break;
							}
						}
					}
					if(NULL == tag)
					{
						if(NO == [self ContainsString:INFO_OPTION_TAGS Target:name])
						{
							[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																							 Message:[NSString stringWithFormat:@"必須有%@節點.",name]]];
						}
						continue;
					}
					
					NSString *tagValue = [NSString stringWithCString:(char*)tag ->content encoding:NSUTF8StringEncoding];
					if(YES == [self DictionaryContainsKey:INFO_REGEX_DIC Key:name])
					{
						NSRegularExpression *regex = [INFO_REGEX_DIC objectForKey:name];
						if(0 == [regex numberOfMatchesInString:tagValue
													   options:NSMatchingReportProgress
														 range:NSRangeFromString(tagValue)])
						{
							[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																							 Message:[NSString stringWithFormat:@"%@節點資料格式錯誤.",name]]];
						}
					}
					if(YES == [self DictionaryContainsKey:INFO_VALID_DIC Key:name])
					{
						if(NO == [self ContainsString:[INFO_VALID_DIC objectForKey:name] Target:tagValue])
						{
							[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																							 Message:[NSString stringWithFormat:@"%@節點資料錯誤.",name]]];
							continue;
						}
					}
					
					if([name isEqualToString:@"eventCode"] || [name isEqualToString:@"parameter"])
					{
						for (NSString *elementName in @[@"valueName", @"value"])
						{
							xmlNodePtr target = NULL;
							for(xmlNodePtr node = tag -> children;node; node = node ->next)
							{
								if(NULL != node)
								{
									if([[NSString stringWithCString:((char*)node -> name) encoding:NSUTF8StringEncoding] isEqualToString:elementName])
									{
										target = node;
										break;
									}
								}
							}
							if(NULL == target)
							{
								[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																								 Message:[NSString stringWithFormat:@"%@節點缺少%@.",name,elementName]]];
							}
						}
					}
					else if([name isEqualToString:@"resource"])
					{
						for (NSString *elementName in @[@"resourceDesc", @"mimeType"])
						{
							xmlNodePtr target = NULL;
							for(xmlNodePtr node = tag -> children;node; node = node ->next)
							{
								if(NULL != node)
								{
									if([[NSString stringWithCString:((char*)node -> name) encoding:NSUTF8StringEncoding] isEqualToString:elementName])
									{
										target = node;
										break;
									}
								}
							}
							if(NULL == target)
							{
								[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																								 Message:[NSString stringWithFormat:@"%@節點缺少%@.",name,elementName]]];
							}
						}
					}
					else if([name isEqualToString:@"area"])
					{
						for (NSString *elementName in @[@"areaDesc"])
						{
							xmlNodePtr target = NULL;
							for(xmlNodePtr node = tag -> children;node; node = node ->next)
							{
								if(NULL != node)
								{
									if([[NSString stringWithCString:((char*)node -> name) encoding:NSUTF8StringEncoding] isEqualToString:elementName])
									{
										target = node;
										break;
									}
								}
							}
							if(NULL == target)
							{
								[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																								 Message:[NSString stringWithFormat:@"%@節點缺少%@.",name,elementName]]];
							}
						}
						
						for(xmlNodePtr nodeGeoCode = tag -> children;nodeGeoCode; nodeGeoCode = nodeGeoCode ->next)
						{
							if(NULL != nodeGeoCode)
							{
								if([[NSString stringWithCString:((char*)nodeGeoCode -> name) encoding:NSUTF8StringEncoding] isEqualToString:@"geocode"])
								{
									for (NSString *elementName in @[@"valueName", @"value"])
									{
										xmlNodePtr target = NULL;
										for(xmlNodePtr node = nodeGeoCode -> children;node; node = node ->next)
										{
											if(NULL != node)
											{
												if([[NSString stringWithCString:((char*)node -> name) encoding:NSUTF8StringEncoding] isEqualToString:elementName])
												{
													target = node;
													break;
												}
											}
										}
										if(NULL == target)
										{
											[capValidateResults addObject:[[CapValidateResult alloc] initWithSubject:name
																											 Message:[NSString stringWithFormat:@"%@節點缺少%@.",name,elementName]]];
										}
									}
								}
							}
						}
					}
					
				}

			}
		}
	}

	return capValidateResults;
}

@end
