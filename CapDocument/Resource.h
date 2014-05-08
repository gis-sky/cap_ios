//
//  Resource.h
//  CapDocument
//
//  Created by snowdaily on 2014/3/19.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resource : NSObject

@property(strong, nonatomic)	NSString	*resourceDesc;
@property(strong, nonatomic)	NSString	*mimeType;
@property(assign, nonatomic)	NSInteger	 size;
@property(strong, nonatomic)	NSString	*uri;
@property(strong, nonatomic)	NSString	*derefUri;
@property(strong, nonatomic)	NSString	*digest;

-(id)initWithResourceDesc:(NSString*)resourceDesc;

@end
