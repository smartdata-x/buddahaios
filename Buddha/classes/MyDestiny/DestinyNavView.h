//
//  DestinyNavView.h
//  Buddha
//
//  Created by Archer_LJ on 15/7/16.
//  Copyright (c) 2015年 Archer_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    DESTINYNAV_BUDDHABOOK = 929,
    DESTINYNAV_HOMEWORK,
    DESTINYNAV_CALI,
    
    DESTINYNAV_CURRENT,
};

@protocol DestinyNavViewDelegate <NSObject>

@optional
- (void)didDestinyNavClickedAtIndex:(NSInteger)index;

@end

@interface DestinyNavView : UIView
@property (nonatomic, assign) id<DestinyNavViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *itemArray;

- (id)initWithFrame:(CGRect)frame;
@end
