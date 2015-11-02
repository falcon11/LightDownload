//
//  PlayerSetting.h
//  LightDownload
//
//  Created by starnet on 11/2/15.
//  Copyright © 2015 com.evideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define SCALINGMODEKEY @"scalingMode"   //拉伸模式宏
#define CONTROLSTYLEKEY @"controlStyle"
#define BACKGROUNDCOLORKEY @"backgroundColor"

@interface PlayerSetting : NSObject

+ (void)writeDefaultValue;
+ (MPMovieScalingMode)scalingMode;
+ (MPMovieControlStyle)controlStyle;
+ (UIColor*)backgroundColor;

@end
