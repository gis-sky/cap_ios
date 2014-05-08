//
//  Parameter.h
//  CapDocument
//
//  Created by snowdaily on 2014/3/19.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parameter : NSObject

@property(strong, nonatomic)	NSString	*valueName;
@property(strong, nonatomic)	NSString	*value;

-(id)initWithValueName:(NSString*)valueName Value:(NSString*)value;

@end
