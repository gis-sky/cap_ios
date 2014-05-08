//
//  CapDocumentSetting.m
//  CapDocument
//
//  Created by snowdaily on 2014/3/19.
//  Copyright (c) 2014年 NCDR. All rights reserved.
//

#import "CapDocumentSetting.h"

@implementation CapDocumentSetting


+(NSString*)geoRssItemTemplate
{
	return
	@"<entry><!-- 第一個CAP --><!--每一個CAP各放在不同的entry-->"
	"<id>{{identifier}}</id> <!-- <identifier> -->"
	"<title>{{event}}</title><!-- <event> -->"
	"<updated>{{sent}}</updated><!-- <sent> -->"
	"<author>"
	"<name>{{sender}}</name><!-- <sender> -->"
	"</author>"
	"<link  /><!-- 留白 -->"
	"<summary type=\"html\"><!-- <description> -->"
	"{{description}}"
	"</summary>"
	"<category term=\"{{event}}\" /><!-- <event> -->"
	"<georss:where>"
	"<gml:MultiPolygon srsName=\"EPSG:4326\"><!-- 不管是不是同一個<info>，所有的<area>的<geocode>、<polygon>或<circle>都轉成polygon放在這一區 -->"
	"{{multipolygon}}"
	"</gml:MultiPolygon>"
	"</georss:where>"
	"</entry>";
}

+(NSString*)geoRssItemPolygonTemplate
{
	return
	@"<gml:polygonMember>"
	"<gml:Polygon>"
	"<gml:outerBoundaryIs>"
	"<gml:LinearRing>"
	"<gml:coordinates>"
	"%@"
	"</gml:coordinates>"
	"</gml:LinearRing>"
	"</gml:outerBoundaryIs>"
	"</gml:Polygon>"
	"</gml:polygonMember>";
}

+(NSString*)geoRssItemGeoCodeTemplate
{
	return @"<gml:polygonMember>%@</gml:polygonMember>";
}

+(NSString*)kmlTemplate
{
	return
	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
	"<kml xmlns=\"http://www.opengis.net/kml/2.2\">"
	"<Document>"
	"<Style id=\"transBluePoly\"><!-- 繪圖所需顏色請參見\"CAP轉KML塗色說明\" -->"
	"<LineStyle>"
	"<width>1.5</width>"
	"</LineStyle>"
	"<PolyStyle>"
	"<color>7dff0000</color>"
	"</PolyStyle>"
	"</Style>"
	"<name>alert</name><!-- name固定為alert -->"
	"<description><!-- 將cap裡<alert>內的欄位都放這裡 -->"
	"{{alert}}"
	"</description>"
	"{{info}}"
	"</Document>"
	"</kml>";
}

+(NSString*)kmlAreaPolygonTemplate
{
	return
	@"<Polygon><!-- 放<polygon> 或<geocode>、<circle>轉成的polygon -->"
	"<tessellate>1</tessellate>"
	"<altitudeMode>absolute</altitudeMode>"
	"<outerBoundaryIs>"
	"<LinearRing>"
	"<coordinates><!-- 下列座標是舉例說明，實際需將cap裡的geocode或circle轉成polygon。高度的設定均為0(貼地表)) -->"
	"%@"
	"</coordinates>"
	"</LinearRing>"
	"</outerBoundaryIs>"
	"</Polygon>";
}

+(NSString*)kmlAreaTemplate
{
	return
	@"<Polygon><!-- 放<polygon> 或<geocode>、<circle>轉成的polygon -->"
	"<tessellate>1</tessellate>"
	"<altitudeMode>absolute</altitudeMode>"
	"<outerBoundaryIs>"
	"<LinearRing>"
	"<coordinates><!-- 下列座標是舉例說明，實際需將cap裡的geocode或circle轉成polygon。高度的設定均為0(貼地表)) -->"
	"%@"
	"</coordinates>"
	"</LinearRing>"
	"</outerBoundaryIs>"
	"</Polygon>"
	"<Placemark><!-- 不同的<area>放在不同的Placemark -->"
	"<name>%@</name><!-- 放<areaDesc> -->"
	"<visibility>1</visibility>"
	"<styleUrl>#transBluePoly</styleUrl>"
	"%@"
	"<description><!-- <area>裡除了<areaDesc> <polygon> <circle> <geocode>的其他欄位都放這裡 -->"
	"%@"
	"</description>"
	"</Placemark>";
}

+(NSString*)kmlAreaScopeTemplate
{
	return
	@"<Folder><!-- cap裡一個<info>可以對應多個<area>，所以用folder把所有的<area>包起來，不同的<area>用底下的Placemark區分，但是都放在同一個folder -->"
	"<name>area</name><!-- name固定為area -->"
	"%@"
	"<!-- 若一個<area>內有多個<geocode>或<polygon>、<circle>，由於KML的規則在一個placemark內不能有多個polygon，所以要拆成多個placemark -->"
	"<!-- 承上，多個<geocode>或<polygon>、<circle>拆成多個placemark時，除了coordinates欄位內容不一樣之外，其他欄位內容都相同 -->"
	"</Folder>";
}

+(NSString*)kmlResourceTemplate
{
	return
	@"<description><!-- 第一個<resource>內的欄位放這裡 -->"
	"%@"
	"</description>";
}
+(NSString*)kmlResourceScopeTemplate
{
	return
	@"<Folder><!-- cap裡一個<info>可以對應多個<resource>，所以用folder把全部的<resource>都包起來，不同的<resource>用description區分，但是都放在同一個folder -->"
	"<name>resource</name><!-- name固定為resource -->"
	"%@"
	"</Folder>";
}
+(NSString*)kmlInfoTemplate
{
	return
	@"<Folder><!-- cap裡一個<alert>可以對應多個<info>，所以用folder把<info>包起來，不同的<info>放在不同的folder -->"
	"<name>info</name><!-- name固定為info -->"
	"<description><!-- 將<info>內的欄位都放這裡 -->"
	"%@"
	"</description>"
	"%@"
	"%@"
	"</Folder>";
}
@end
