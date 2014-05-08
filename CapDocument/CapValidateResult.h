//
//  CapValidateResult.h
//  CapDocument
//
//  Created by snowdaily on 2014/3/17.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CapValidateResult : NSObject

@property(strong, nonatomic, readonly)	NSString	*subject;
@property(strong, nonatomic, readonly)	NSString	*message;

-(id)initWithSubject:(NSString*)aSubject Message:(NSString*)aMessage;

@end
