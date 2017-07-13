//
//  YQPCDView.h
//  YQPCDPickerViewSample
//
//  Created by OSX on 17/7/13.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YQPCDViewDelegate <NSObject>

@required
- (void)doneBackForProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;

@end

@interface YQPCDView : UIButton

@property (weak, nonatomic) id<YQPCDViewDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)createPCDViewAddTo:(UIView *)view;

@end
