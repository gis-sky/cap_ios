//
//  CapValidator.h
//  CapDocument
//
//  Created by snowdaily on 2014/3/18.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/parser.h>
#import <libxml/tree.h>

@interface CapValidator : NSObject

+(NSArray*)Validate:(xmlDoc*)xDocument;

@end
