//
//  MapFeatureTableViewCell.h
//  Buddha
//
//  Created by Archer_LJ on 14/12/12.
//  Copyright (c) 2014年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface migsBuildingInfo : NSObject

@property (nonatomic, retain) NSString *buildId;
@property (nonatomic, retain) NSString *buildType;
@property (nonatomic, retain) NSString *headUrl;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;

@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *detailInfo;

@property (nonatomic, assign) float fDistance;
@property (nonatomic, assign) float fLatitude;
@property (nonatomic, assign) float fLongitude;

+ (migsBuildingInfo *)setupBuildingInfoFromDictionary:(NSDictionary *)dic;

@end

@interface MapFeatureTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *avatarImg;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblDetail;
@property (nonatomic, retain) IBOutlet UILabel *lblDistance;

- (void)initCellWithData:(migsBuildingInfo *)buildingInfo;

@end
