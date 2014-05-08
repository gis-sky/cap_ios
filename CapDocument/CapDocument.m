//
//  CapDocument.m
//  CapDocument
//
//  Created by snowdaily on 2014/3/17.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import "CapDocument.h"
#import "CapValidator.h"
#import "Info.h"
#import "EventCode.h"
#import "Parameter.h"
#import "Resource.h"
#import "Area.h"
#import "GeoCode.h"
#import "CapDocumentSetting.h"
#import "GeoCodeUtility.h"
#import <libxml/parser.h>

@interface CapDocument()
{
	@private NSMutableArray	*capValidateResults;
}
@property(strong, nonatomic)	NSMutableArray	*code;
@property(strong, nonatomic)	NSMutableArray	*info;

@end

@implementation CapDocument
@synthesize code, info;

-(id)init
{
	if(self = [super init])
	{
		code = [NSMutableArray new];
		info = [NSMutableArray new];
		
		capValidateResults = [NSMutableArray new];
	}
	return self;
}

-(id)initWithFilePath:(NSString*)filePath
{
	if(self = [self init])
	{
		[self load:filePath];
	}
	return self;
}

-(void)load:(NSString*)filePath
{
	xmlDocPtr xDocument = NULL;
	
	@try
	{
		xDocument = xmlReadFile([filePath UTF8String], "UTF8", XML_PARSE_RECOVER);
		[capValidateResults addObjectsFromArray:[CapValidator Validate:xDocument]];
		
		if(capValidateResults.count == 0)
		{
			[self perform:xDocument];
		}
	}
	@catch (NSException *exception)
	{
		@throw exception;
	}
	@finally
	{
		if(NULL != xDocument)
		{
			xmlFreeDoc(xDocument);
		}
	}
}

-(BOOL)isValid
{
	return capValidateResults.count > 0;
}

-(CapValidateResult*)Validate
{
	return [[CapValidateResult alloc]initWithSubject:@"" Message:@""];
}

+(CapValidateResult*)Validate:(NSString*)filePath
{
	return [[CapValidateResult alloc]initWithSubject:@"" Message:@""];
}

-(NSString*)toJson
{
	NSError *writeError = nil;
	
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
													   options:NSJSONWritingPrettyPrinted
														 error:&writeError];
	
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	
    return result;
}

-(NSString*)toGeoRssItem
{
	NSString *result = [self ReplaceContent:[CapDocumentSetting geoRssItemTemplate] Target:@"identifier" Content:self.identifier];
	result = [self ReplaceContent:result Target:@"sent" Content:self.sent];
	result = [self ReplaceContent:result Target:@"sender" Content:self.sender];

	NSString *_event = @"";
	NSMutableString *sbMultiPolygon = [NSMutableString new];
	if(self.info.count > 0)
	{
		result = [self ReplaceContent:result Target:@"description" Content:((Info*)self.info[0]).description];
		_event = ((Info*)self.info[0]).event;
		
		for (Info *i in self.info)
		{
			if(i.area.count > 0)
			{
				for (Area *a in i.area)
				{
					if(a.circle.count > 0)
					{
						[sbMultiPolygon appendFormat:[CapDocumentSetting geoRssItemPolygonTemplate],[a.circle componentsJoinedByString:@" "]];
					}
					if(a.polygon.count > 0)
					{
						[sbMultiPolygon appendFormat:[CapDocumentSetting geoRssItemPolygonTemplate],[a.polygon componentsJoinedByString:@" "]];
					}
					if(a.geocode.count > 0)
					{
						for (GeoCode *g in a.geocode)
						{
							[sbMultiPolygon appendFormat:[CapDocumentSetting geoRssItemGeoCodeTemplate],[GeoCodeUtility getPolygon:g.value Type:@"gml"]];
						}
					}
				}
			}
		}
		result = [self ReplaceContent:result Target:@"multipolygon" Content:sbMultiPolygon];
	}
	result = [self ReplaceContent:result Target:@"event" Content:_event];
	
	return result;
}

-(NSString*)toKml
{
	// alert
	NSMutableString *sbAlert = [NSMutableString new];
	[sbAlert appendFormat:@"<%@>%@</%@>", @"identifier", self.identifier, @"identifier"];
	[sbAlert appendFormat:@"<%@>%@</%@>", @"sender", self.sender, @"sender"];
	[sbAlert appendFormat:@"<%@>%@</%@>", @"sent", self.sent, @"sent"];
	[sbAlert appendFormat:@"<%@>%@</%@>", @"status", self.status, @"status"];
	[sbAlert appendFormat:@"<%@>%@</%@>", @"msgType", self.msgType, @"msgType"];
	
	if(nil == self.source ? NO : self.source.length > 0)
	{
		[sbAlert appendFormat:@"<%@>%@</%@>", @"source", self.source, @"source"];
	}
    [sbAlert appendFormat:@"<%@>%@</%@>", @"scope", self.scope, @"scope"];
	
	if(nil == self.restriction ? NO : self.restriction.length > 0)
	{
		[sbAlert appendFormat:@"<%@>%@</%@>", @"restriction", self.restriction, @"restriction"];
	}
	if(nil == self.addresses ? NO : self.addresses.length > 0)
	{
		[sbAlert appendFormat:@"<%@>%@</%@>", @"addresses", self.addresses, @"addresses"];
	}
	
	if (self.code.count > 0)
	{
		for (NSString *c in code)
		{
			[sbAlert appendFormat:@"<%@>%@</%@>", @"code", c,@"code"];
		}
	}
	if(nil == self.note ? NO : self.note.length > 0)
	{
		[sbAlert appendFormat:@"<%@>%@</%@>", @"note", self.note, @"note"];
	}
	if(nil == self.references ? NO : self.references.length > 0)
	{
		[sbAlert appendFormat:@"<%@>%@</%@>", @"references", self.references,@"references"];
	}
	if(nil == self.incidents ? NO : self.incidents.length > 0)
	{
		[sbAlert appendFormat:@"<%@>%@</%@>", @"incidents", self.incidents,@"incidents"];
	}
	NSString *result = [self ReplaceContent:[CapDocumentSetting kmlTemplate] Target:@"alert" Content:sbAlert];
	
	// info
	NSMutableString *sbInfo = [NSMutableString new];
	if (self.info.count > 0)
	{
		for (Info *i in self.info)
		{
			NSMutableString *sbInfoItem = [NSMutableString new];
			if (nil == i.language ? NO : i.language.length > 0)
			{
				[sbInfoItem appendFormat:@"<%@>%@</%@>", @"language", i.language,@"language"];
			}
			if (i.category.count > 0)
			{
				for (NSString *c in i.category)
				{
					[sbInfoItem appendFormat:@"<%@>%@</%@>", @"category", c,@"category"];
				}
			}
			[sbInfoItem appendFormat:@"<%@>%@</%@>", @"event", i.event,@"event"];
			if (i.responseType.count > 0)
			{
				for (NSString *r in i.responseType)
				{
					[sbInfoItem appendFormat:@"<%@>%@</%@>", @"responseType", r,@"responseType"];
				}
			}
			[sbInfoItem appendFormat:@"<%@>%@</%@>", @"urgency", i.urgency, @"urgency"];
			[sbInfoItem appendFormat:@"<%@>%@</%@>", @"severity", i.severity, @"severity"];
			[sbInfoItem appendFormat:@"<%@>%@</%@>", @"certainty", i.certainty, @"certainty"];
			[self SetContent:sbInfoItem TagName:@"audience" Content:i.audience];
			if (i.eventCode.count > 0)
			{
				for (EventCode *e in i.eventCode)
				{
					NSString *contentString = [NSString stringWithFormat:@"<%@>%@</%@><%@>%@</%@>", @"valueName", e.valueName, @"valueName", @"value", e.value,@"value"];
					[sbInfoItem appendFormat:@"<%@>%@</%@>", @"eventCode", contentString, @"eventCode"];
				}
			}
			[self SetContent:sbInfoItem TagName:@"effective" Content:i.effective];
			[self SetContent:sbInfoItem TagName:@"onset"  Content:i.onset];
			[self SetContent:sbInfoItem TagName:@"expires"  Content:i.expires];
			[self SetContent:sbInfoItem TagName:@"senderName"  Content:i.senderName];
			[self SetContent:sbInfoItem TagName:@"headline"  Content:i.headline];
			[self SetContent:sbInfoItem TagName:@"description"  Content:i.description];
			[self SetContent:sbInfoItem TagName:@"instruction" Content:i.instruction];
			[self SetContent:sbInfoItem TagName:@"web"  Content:i.web];
			[self SetContent:sbInfoItem TagName:@"contact"  Content:i.contact];
			[self SetContent:sbInfoItem TagName:@"headline"  Content:i.headline];
			if (i.parameter.count > 0)
			{
				for (Parameter *p in i.parameter)
				{
					NSString *contentString = [NSString stringWithFormat:@"<%@>%@</%@><%@>%@</%@>", @"valueName", p.valueName, @"valueName",@"value", p.value,@"value"];
					[sbInfoItem appendFormat:@"<%@>%@</%@>", @"parameter", contentString, @"parameter"];
				}
			}
			
			// area
			NSMutableString *sbArea = [NSMutableString new];
			if (i.area.count > 0)
			{
				NSMutableString *sbAreaItem = [NSMutableString new];
				for (Area *a in i.area)
				{
					NSMutableString *sbAreaPolygon = [NSMutableString new];
					if (a.polygon.count > 0)
					{
						[sbAreaPolygon appendFormat:[CapDocumentSetting kmlAreaPolygonTemplate], @"polygon", [a.polygon componentsJoinedByString:@" "]];
					}
					if (a.circle.count > 0)
					{
						[sbAreaPolygon appendFormat:[CapDocumentSetting kmlAreaPolygonTemplate], @"circle", [a.circle componentsJoinedByString:@" "]];
					}
					if (a.geocode.count > 0)
					{
						for (GeoCode *g in a.geocode)
						{
							[sbAreaPolygon appendString:[GeoCodeUtility getPolygon:g.value Type:@"kml"]];
						}
					}
					NSMutableString *sbAreaOther = [NSMutableString new];
					[self SetContent:sbAreaOther TagName:@"altitude" Content:[NSString stringWithFormat:@"%ld", (long)a.altitude]];
					[self SetContent:sbAreaOther TagName:@"ceiling" Content:[NSString stringWithFormat:@"%ld", (long)a.ceiling]];
					[sbAreaItem appendFormat:[CapDocumentSetting kmlAreaTemplate], a.areaDesc, a.areaDesc,sbAreaPolygon,sbAreaOther];
				}
				[sbArea appendFormat:[CapDocumentSetting kmlAreaScopeTemplate], sbAreaItem];
			}
			
			// resource
			NSMutableString *sbResource = [NSMutableString new];
			if (i.resource.count > 0)
			{
				NSMutableString *sbResourceItem = [NSMutableString new];
				for (Resource *r in i.resource)
				{
					[self SetContent:sbResourceItem TagName:@"resourceDesc" Content:r.resourceDesc];
					[self SetContent:sbResourceItem TagName:@"mimeType" Content:r.mimeType];
					[self SetContent:sbResourceItem TagName:@"size" Content:[NSString stringWithFormat:@"%ld",(long)r.size]];
					[self SetContent:sbResourceItem TagName:@"uri" Content:r.uri];
					[self SetContent:sbResourceItem TagName:@"derefUri" Content:r.derefUri];
					[self SetContent:sbResourceItem TagName:@"digest" Content:r.digest];
					[sbResourceItem appendFormat:[CapDocumentSetting kmlResourceTemplate], sbResourceItem];
				}
				[sbResource appendFormat:[CapDocumentSetting kmlResourceScopeTemplate], sbResourceItem];
			}
			
			[sbInfo appendFormat:[CapDocumentSetting kmlInfoTemplate], sbInfoItem, sbArea, sbResource];
		}
	}
	result = [self ReplaceContent:result Target:@"info" Content:sbInfo];
	
	return result;
}

-(void)perform:(xmlDocPtr)xDocument
{
	if(NULL == xDocument)
	{
		[NSException raise:@"Null Reference Exception" format:@"xDocument is NULL"];
	}
	
	xmlNodePtr rootNode = xmlDocGetRootElement(xDocument);
	
	for(xmlNodePtr node = rootNode -> children;node;node = node -> next)
	{
		NSString *tagName = [self ToNSString:node -> name];
		
		if([tagName isEqualToString:@"identifier"] && 0 == self.identifier.length)
		{
			self.identifier = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"sender"] && 0 == self.sender.length)
		{
			self.sender = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"sent"] && 0 == self.sent.length)
		{
			self.sent = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"status"] && 0 == self.status.length)
		{
			self.status = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"msgType"] && 0 == self.msgType.length)
		{
			self.msgType = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"source"] && 0 == self.source.length)
		{
			self.source = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"scope"] && 0 == self.scope.length)
		{
			self.scope = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"restriction"] && 0 == self.restriction.length)
		{
			self.restriction = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"addresses"] && 0 == self.addresses.length)
		{
			self.addresses = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"code"])
		{
			[self.code addObject:[self ToNSString:node -> content]];
		}
		if([tagName isEqualToString:@"note"] && 0 == self.note.length)
		{
			self.note = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"references"] && 0 == self.references.length)
		{
			self.references = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"incidents"] && 0 == self.incidents.length)
		{
			self.incidents = [self ToNSString:node -> content];
		}
		if([tagName isEqualToString:@"info"])
		{
			Info *i = [Info new];
			for(xmlNodePtr infoElements = node -> children;infoElements;infoElements = infoElements->next)
			{
				NSString *iTagName = [self ToNSString:infoElements -> name];
			
				if([iTagName isEqualToString:@"language"] && 0 == i.language.length)
				{
					[i setValue:LANGUAGE Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"category"])
				{
					[i.category addObject:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"event"] && 0 == i.event.length)
				{
					[i setValue:EVENT Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"responseType"])
				{
					[i.responseType addObject:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"urgency"] && 0 == i.urgency.length)
				{
					[i setValue:URGENCY Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"severity"] && 0 == i.severity.length)
				{
					[i setValue:SEVERITY Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"certainty"] && 0 == i.certainty.length)
				{
					[i setValue:CERTAINTY Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"audience"] && 0 == i.audience.length)
				{
					[i setValue:AUDIENCE Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"eventCode"])
				{
					EventCode *eventCodeObj = [[EventCode alloc] initWithValueName:@"" Value:@""];
					
					for(xmlNodePtr eventCodeElements = infoElements -> children;eventCodeElements;eventCodeElements = eventCodeElements->next)
					{
						if([[self ToNSString:eventCodeElements -> name] isEqualToString:@"valueName"])
						{
							eventCodeObj.valueName = [self ToNSString:eventCodeElements -> content];
						}
						if([[self ToNSString:eventCodeElements -> name] isEqualToString:@"value"])
						{
							eventCodeObj.value = [self ToNSString:eventCodeElements -> content];
						}
					}
					
					[i.eventCode addObject:eventCodeObj];
				}
				if([iTagName isEqualToString:@"effective"] && 0 == i.effective.length)
				{
					[i setValue:EFFECTIVE Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"onset"] && 0 == i.onset.length)
				{
					[i setValue:ONSET Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"expires"] && 0 == i.expires.length)
				{
					[i setValue:EXPIRES Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"senderName"] && 0 == i.senderName.length)
				{
					[i setValue:SENDERNAME Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"headline"] && 0 == i.headline.length)
				{
					[i setValue:HEADLINE Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"description"] && 0 == i.description.length)
				{
					[i setValue:DESCRIPTION Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"instruction"] && 0 == i.instruction.length)
				{
					[i setValue:INSTRUCTION Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"web"] && 0 == i.web.length)
				{
					[i setValue:WEB Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"contact"] && 0 == i.contact.length)
				{
					[i setValue:CONTACT Value:[self ToNSString:infoElements -> content]];
				}
				if([iTagName isEqualToString:@"parameter"])
				{
					Parameter *parameterObj = [[Parameter alloc] initWithValueName:@"" Value:@""];
					
					for(xmlNodePtr parameterElements = infoElements -> children;parameterElements;parameterElements = parameterElements->next)
					{
						if([[self ToNSString:parameterElements -> name] isEqualToString:@"valueName"])
						{
							parameterObj.valueName = [self ToNSString:parameterElements -> content];
						}
						if([[self ToNSString:parameterElements -> name] isEqualToString:@"value"])
						{
							parameterObj.value = [self ToNSString:parameterElements -> content];
						}
					}
					
					[i.parameter addObject:parameterObj];
				}
				if([iTagName isEqualToString:@"resource"])
				{
					Resource *resourceObj = [Resource new];
					
					for(xmlNodePtr resourceElements = infoElements -> children;resourceElements;resourceElements = resourceElements->next)
					{
						if([[self ToNSString:resourceElements -> name] isEqualToString:@"resourceDesc"])
						{
							resourceObj.resourceDesc = [self ToNSString:resourceElements -> content];
						}
						if([[self ToNSString:resourceElements -> name] isEqualToString:@"mimeType"])
						{
							resourceObj.mimeType = [self ToNSString:resourceElements -> content];
						}
						if([[self ToNSString:resourceElements -> name] isEqualToString:@"size"])
						{
							resourceObj.size = [self ToNSString:resourceElements -> content].integerValue;
						}
						if([[self ToNSString:resourceElements -> name] isEqualToString:@"uri"])
						{
							resourceObj.uri = [self ToNSString:resourceElements -> content];
						}
						if([[self ToNSString:resourceElements -> name] isEqualToString:@"derefUri"])
						{
							resourceObj.derefUri = [self ToNSString:resourceElements -> content];
						}
						if([[self ToNSString:resourceElements -> name] isEqualToString:@"digest"])
						{
							resourceObj.digest = [self ToNSString:resourceElements -> content];
						}
					}
					
					[i.resource addObject:resourceObj];
				}
				if([iTagName isEqualToString:@"area"])
				{
					Area *areaObj = [Area new];
					
					for(xmlNodePtr areaElements = infoElements -> children;areaElements;areaElements = areaElements->next)
					{
						if([[self ToNSString:areaElements -> name] isEqualToString:@"areaDesc"])
						{
							areaObj.areaDesc = [self ToNSString:areaElements -> content];
						}
						if([[self ToNSString:areaElements -> name] isEqualToString:@"geocode"])
						{
							GeoCode *geocodeObj = [GeoCode new];
							for(xmlNodePtr geocodeElements = areaElements -> children;geocodeElements;geocodeElements = geocodeElements->next)
							{
								if([[self ToNSString:geocodeElements -> name] isEqualToString:@"valueName"])
								{
									geocodeObj.valueName = [self ToNSString:geocodeElements -> content];
								}
								if([[self ToNSString:geocodeElements -> name] isEqualToString:@"value"])
								{
									geocodeObj.value = [self ToNSString:geocodeElements -> content];
								}
							}
							[areaObj.geocode addObject:geocodeObj];
						}
						if([[self ToNSString:areaElements -> name] isEqualToString:@"polygon"])
						{
							[areaObj.polygon addObject:[self ToNSString:areaElements -> content]];
						}
						if([[self ToNSString:areaElements -> name] isEqualToString:@"circle"])
						{
							[areaObj.circle addObject:[self ToNSString:areaElements -> content]];
						}
						if([[self ToNSString:areaElements -> name] isEqualToString:@"altitude"])
						{
							areaObj.altitude = [self ToNSString:areaElements -> content].integerValue;
						}
						if([[self ToNSString:areaElements -> name] isEqualToString:@"ceiling"])
						{
							areaObj.ceiling = [self ToNSString:areaElements -> content].integerValue;
						}
					}
					
					[i.area addObject:areaObj];
				}
				
				[self.info addObject:i];
			}
		}
	}
}

-(NSString*)ToNSString:(const xmlChar*)c
{
	return [NSString stringWithCString:(char*)c encoding:NSUTF8StringEncoding];
}

-(NSString*)ReplaceContent:(NSString*)temp Target:(NSString*)target Content:(NSString*)content
{
	NSString *targetReplace = [NSString stringWithFormat:@"{{%@}}", target];
	return [temp stringByReplacingOccurrencesOfString:targetReplace withString:content];
}

-(NSString*)SetContent:(NSMutableString*)sb TagName:(NSString*)tagName Content:(NSString*)content
{
	if(nil == content ? NO : content.length > 0)
	{
		[sb appendFormat:@"<%@>%@</%@>", tagName, content, tagName];
	}
	return sb;
}
@end
