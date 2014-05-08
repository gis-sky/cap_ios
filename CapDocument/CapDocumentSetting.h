//
//  CapDocumentSetting.h
//  CapDocument
//
//  Created by snowdaily on 2014/3/19.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CapDocumentSetting : NSObject


+(NSString*)geoRssItemTemplate;
+(NSString*)geoRssItemPolygonTemplate;
+(NSString*)geoRssItemGeoCodeTemplate;
+(NSString*)kmlTemplate;
+(NSString*)kmlAreaPolygonTemplate;
+(NSString*)kmlAreaTemplate;
+(NSString*)kmlAreaScopeTemplate;
+(NSString*)kmlResourceTemplate;
+(NSString*)kmlResourceScopeTemplate;
+(NSString*)kmlInfoTemplate;

@end
