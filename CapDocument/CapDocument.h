//
//  CapDocument.h
//  CapDocument
//
//  Created by snowdaily on 2014/3/17.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CapValidateResult.h"

@interface CapDocument : NSObject

@property(strong, nonatomic)			NSString		*identifier;
@property(strong, nonatomic)			NSString		*sender;
@property(strong, nonatomic)			NSString		*sent;
@property(strong, nonatomic)			NSString		*status;
@property(strong, nonatomic)			NSString		*msgType;
@property(strong, nonatomic)			NSString		*source;
@property(strong, nonatomic)			NSString		*scope;
@property(strong, nonatomic)			NSString		*restriction;
@property(strong, nonatomic)			NSString		*addresses;
@property(strong, nonatomic, readonly)	NSMutableArray	*code;
@property(strong, nonatomic)			NSString		*note;
@property(strong, nonatomic)			NSString		*references;
@property(strong, nonatomic)			NSString		*incidents;
@property(strong, nonatomic, readonly)	NSMutableArray	*info;


-(id)initWithFilePath:(NSString*)filePath;
-(void)load:(NSString*)filePath;
-(BOOL)isValid;
-(CapValidateResult*)Validate;
+(CapValidateResult*)Validate:(NSString*)filePath;
-(NSString*)toJson;
-(NSString*)toGeoRssItem;
-(NSString*)toKml;

@end
