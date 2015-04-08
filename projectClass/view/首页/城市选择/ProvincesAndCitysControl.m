//
//  ProvincesAndCitysControl.m
//  yglyProject
//
//  Created by 枫 on 14-10-10.
//  Copyright (c) 2014年 雷海. All rights reserved.
//

#import "ProvincesAndCitysControl.h"
#import "Utility.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "HBJNSString.h"
#import "HBJNSMutableArray.h"

static ProvincesAndCitysControl *share = nil;
@implementation ProvincesAndCitysControl

-(void)dealloc{
    
    self.plistFile = nil;
    [_provinceArray release];_provinceArray = nil;
    
    [super dealloc];
}

+(ProvincesAndCitysControl *)shareInstance{
   

    if (!share) {
        share = [[ProvincesAndCitysControl alloc] initWithPlistFile:@"ProvincesAndCities.plist"];
    }
    return share;
}
- (instancetype)initWithPlistFile:(NSString *)filePath;
{
    self = [super init];
    if (self) {
        
        _provinceArray = [[NSMutableArray alloc] init];
        self.plistFile = filePath;
    }
    return self;
}

#pragma mark - property
-(void)setPlistFile:(NSString *)plistFile{
    if (plistFile){
        if (_plistFile) {
            [_plistFile release];_plistFile = nil;
        }
        _plistFile = [plistFile retain];
        [self loadPlistFile];
    }else{
        EBLog(@"plistFile should not be nil!");
    }
    
}
-(void)loadPlistFile
{
    if (_plistFile == nil){
            
    }else{
        NSString* path = [Utility getPathByName:_plistFile];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
            EBLog(@"file: %@ not exist!",path);
        }else{
            EBLog(@"plistFile exist");
            
            NSArray *tmpArray= [NSArray arrayWithContentsOfFile:[Utility getPathByName:_plistFile]];
            //解析字典中的省份和城市
            //先解析省份
            for (NSDictionary *dic in tmpArray) {
                NSString *provienceStr = [dic objectForKey:@"State"];
                
                ProvinceModel *provinceModel = [self getProvinceModel:provienceStr];
                provinceModel.provienceCode = dic[@"provienceCode"];
                [_provinceArray addObject:provinceModel];
                //省份所对应的城市
                NSArray *tempArray = [dic objectForKey:@"Cities"];
                provinceModel.cityArray = [self getCityModelArray:tempArray provience:provienceStr];
            }
            
            //解析完成后进行后续的排序
            //省份 城市排序
            [_provinceArray SortByKey:@"fullPinYin"];
            for (int i = 0; i < _provinceArray.count; i++) {
                
                 ProvinceModel *model = _provinceArray[i];
                [model.cityArray SortByKey:@"fullPinYin"];
                //如若是 本省 则保存本省的名称到 otherCityCode 读的时候将会把 本省替换掉
                [model.cityArray insertObject:[ProvincesAndCitysControl getCityModelWithCityName:@"本省" provience:model.string lat:0.0 lon:0.0 cityCode:model.provienceCode otherCityCode:model.string]  atIndex:0];
            }
            
            
            //省份城市归类
            [_provinceArray setArray:[NSMutableArray classify2ToGroup:_provinceArray]];
            //城市不用归类
//            for (NSMutableArray *tmpArray in _cityArray) {
//                [tmpArray setArray:[NSMutableArray classify2ToGroup:tmpArray]];
//            }
        }
    }
}

- (ProvinceModel *)getProvinceModel:(NSString *)provinceName{
    
    ProvinceModel *provinceModel = [[[ProvinceModel alloc] init] autorelease];
    provinceModel.string = provinceName;//----1--
    
    if ([provinceName rangeOfString:@"."].location == NSNotFound) {//不允许有.的出现
        
        NSString *outputPinyin = [provinceName convertToHanYuPinYin];
        
        provinceModel.pinYin = [provinceName getPinYinFirstLetter];//----2---
        provinceModel.fullPinYin = outputPinyin;//----3----
    }
    
    return provinceModel;
    
}

#pragma mark -返回一组跟省份相关联的城市列表
- (NSMutableArray *)getCityModelArray:(NSArray *)cityArray
                            provience:(NSString *)provience{
    
    NSMutableArray *tempCityArray = [NSMutableArray array];
    
    for (NSDictionary *dic in cityArray) {
                
        [tempCityArray addObject:[ProvincesAndCitysControl getCityModelWithCityName:[dic strValue:@"city"] provience:provience lat:[dic floatValue:@"lat"] lon:[dic floatValue:@"lon"] cityCode:[dic strValue:@"cityCode"] otherCityCode:[dic strValue:@"otherCode"]]];
    }
    
    return tempCityArray;
}

#pragma mark -返回一个城市模型
+(CityModel *)getCityModelWithCityName:(NSString *)city
                                   provience:(NSString *)provience
                                         lat:(CGFloat)lat
                                         lon:(CGFloat)lon
                                    cityCode:(NSString *)cityCode
                               otherCityCode:(NSString *)otherCityCode
{
    CityModel *cityModel = [[[CityModel alloc] init] autorelease];
    cityModel.string = city;//----1--
    if ([city rangeOfString:@"."].location == NSNotFound) {//不允许有.的出现
        
        NSString *outputPinyin = [city convertToHanYuPinYin];
        cityModel.pinYin = [city getPinYinFirstLetter];
        cityModel.fullPinYin = outputPinyin;//----3----
    }
    
    cityModel.lat = lat;
    cityModel.lon = lon;
    cityModel.provience = provience;
    cityModel.cityCode = cityCode;
    cityModel.otherCityCode = otherCityCode;
    
    return cityModel;
}

#pragma mark 用来返回一组查询结果 - 条件以城市匹配为准
//分为三次查询 汉字被包含查询  首字母被包含查询 全部拼音被包含查询
//city 所要查询的城市名称
//type          0               1               2           3(表示三者若有一个满足便符合条件的查询)
-(NSMutableArray *)searchByCityName:(NSString *)city type:(NSInteger)type{
   
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NSDictionary *dict in _provinceArray) {//取到的是省份被归类后的所被包含的字典
        
        NSArray *provinceArray = [dict objectForKey:[[dict allKeys] objectAtIndex:0]];
        for (ProvinceModel *provinceModel in provinceArray) {
            
            for (CityModel *citymodel in provinceModel.cityArray) {
                
                switch (type) {
                    case 0:
                    {
                        if ([citymodel.string hasPrefix:city]) {
                            [resultArray addObject:citymodel];
                        }
                    }
                        break;
                    case 1:
                    {
                        if ([citymodel.pinYin hasPrefix:[city getPinYinFirstLetter]]) {
                            [resultArray addObject:citymodel];
                        }
                    }
                        break;
                    case 2:
                    {
                        if ([citymodel.fullPinYin hasPrefix:[city convertToHanYuPinYin]]) {
                            [resultArray addObject:citymodel];
                        }
                    }
                        break;
                    case 3:
                    {
                        if ([citymodel.string hasPrefix:city] ||
                            [citymodel.pinYin hasPrefix:[city getPinYinFirstLetter]] ||
                            [citymodel.fullPinYin hasPrefix:[city convertToHanYuPinYin]]) {
                            [resultArray addObject:citymodel];
                        }
                    }
                        break;
                    
                    default:
                        break;
                }
            }
        }
    }
    return (resultArray.count > 0 ? resultArray : nil);
}

-(NSMutableArray *)getCityModelArray:(BOOL (^)(const CityModel *conditionModel))conditionBlock
                    fromArray:(const NSMutableArray *)cityArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 2 ; i< cityArray.count ; i++) {
        NSDictionary *cityDict = [cityArray objectAtIndex:i];
        NSArray *array = [cityDict objectForKey:[[cityDict allKeys] objectAtIndex:0]];
        for (CityModel *model in array) {
            if (conditionBlock(model)) {
                [resultArray addObject:model];
            }
        }
        
    }
    return (resultArray.count > 0 ? resultArray : nil);
}

@end
