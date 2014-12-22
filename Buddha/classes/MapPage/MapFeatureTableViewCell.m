//
//  MapFeatureTableViewCell.m
//  Buddha
//
//  Created by Archer_LJ on 14/12/12.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import "MapFeatureTableViewCell.h"
#import "Stdinc.h"

@implementation migsBuildingInfo

+ (migsBuildingInfo *)setupBuildingInfoFromDictionary:(NSDictionary *)dic {
    
    NSDictionary *basic = [dic objectForKey:@"basic"];
    NSString *buildid = [NSString stringWithFormat:@"%d", [[basic objectForKey:@"id"] intValue]];
    NSString *name = [basic objectForKey:@"name"];
    NSString *pic = [basic objectForKey:@"pic"];
    NSString *type = [NSString stringWithFormat:@"%d", [[basic objectForKey:@"type"] intValue]];
    
    NSDictionary *location = [dic objectForKey:@"location"];
    NSString *address = [location objectForKey:@"address"];
    NSString *city = [location objectForKey:@"city"];
    
    float distance = [[location objectForKey:@"distance"] floatValue];
    float latitude = [[location objectForKey:@"latitude"] floatValue];
    float longitude = [[location objectForKey:@"longitude"] floatValue];
    
    migsBuildingInfo *buildinfo = [[migsBuildingInfo alloc] init];
    buildinfo.buildId = buildid;
    buildinfo.buildType = type;
    buildinfo.name = name;
    buildinfo.headUrl = pic;
    buildinfo.address = address;
    buildinfo.city = city;
    buildinfo.fDistance = distance;
    buildinfo.fLatitude = latitude;
    buildinfo.fLongitude = longitude;
    buildinfo.distance = [NSString stringWithFormat:@"%f", distance];
    buildinfo.latitude = [NSString stringWithFormat:@"%f", latitude];
    buildinfo.longitude = [NSString stringWithFormat:@"%f", longitude];
    
    return buildinfo;
}

@end

@implementation MapFeatureTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCellWithData:(migsBuildingInfo *)buildingInfo {
    
    NSString *imageName = buildingInfo.headUrl;
    NSString *title = buildingInfo.name;
    NSString *detail = buildingInfo.address;
    float distance = buildingInfo.fDistance;
    
    // 图片
    _avatarImg.imageURL = [NSURL URLWithString:imageName];
    
    // 标题
    _lblTitle.text = title;
    _lblTitle.textAlignment = NSTextAlignmentLeft;
    _lblTitle.textColor = MIG_COLOR_111111;
    _lblTitle.font = [UIFont fontOfApp:30.0 / SCREEN_SCALAR];
    
    // 细节
    _lblDetail.text = detail;
    _lblDetail.textAlignment = NSTextAlignmentLeft;
    _lblDetail.textColor = MIG_COLOR_808080;
    _lblDetail.font = [UIFont fontOfApp:24.0 / SCREEN_SCALAR];
    
    // 距离
    _lblDistance.text = [Utilities distanceFromFloat:distance];
    _lblDistance.textAlignment = NSTextAlignmentRight;
    _lblDistance.textColor = MIG_COLOR_808080;
    _lblDistance.font = [UIFont fontOfApp:24.0 / SCREEN_SCALAR];
}

@end
