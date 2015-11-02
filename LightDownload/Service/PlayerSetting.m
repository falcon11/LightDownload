//
//  PlayerSetting.m
//  LightDownload
//
//  Created by starnet on 11/2/15.
//  Copyright © 2015 com.evideo. All rights reserved.
//

#import "PlayerSetting.h"

@implementation PlayerSetting

+ (void)writeDefaultValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:SCALINGMODEKEY];
    if (!value) {
        NSLog(@"can't read default value directly............");
        NSString *settingsBundlePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
        NSString *rootPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:rootPath];
        NSArray *prefSpecifierArray = [dict objectForKey:@"Preference Specifiers"];
        NSNumber *defaultScalingMode = nil;
        NSNumber *defaultControlStyle = nil;
        NSNumber *defaultBackGroundColor = nil;
        
        NSDictionary *itemDic;
        for(itemDic in prefSpecifierArray)
        {
            NSString *keyValueStr = [itemDic objectForKey:@"Key"];
            id defaultValue = [itemDic objectForKey:@"DefaultValue"];
            if ([keyValueStr isEqualToString:SCALINGMODEKEY]) {
                defaultScalingMode = defaultValue;
            }
            else if([keyValueStr isEqualToString:CONTROLSTYLEKEY])
            {
                defaultControlStyle = defaultValue;
            }
            else if ([keyValueStr isEqualToString:BACKGROUNDCOLORKEY])
            {
                defaultBackGroundColor = defaultValue;
            }
        }
        
        NSDictionary *defaultValueDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         defaultScalingMode, SCALINGMODEKEY,
                                         defaultControlStyle, CONTROLSTYLEKEY,
                                         defaultBackGroundColor, BACKGROUNDCOLORKEY,
                                         nil];
        [defaults registerDefaults:defaultValueDic];
        [defaults synchronize];
    }
}

+ (MPMovieScalingMode)scalingMode
{
    [self writeDefaultValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int mode  = [defaults integerForKey:SCALINGMODEKEY];
    return mode;
}

+ (MPMovieControlStyle)controlStyle
{
    [self writeDefaultValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int style = [defaults integerForKey:CONTROLSTYLEKEY];
    return style;
}

+ (UIColor*)backgroundColor
{
    [self writeDefaultValue];
    NSArray *colorArray = [NSArray arrayWithObjects:
                           [UIColor blackColor], [UIColor darkTextColor],
                           [UIColor whiteColor], [UIColor greenColor],
                           [UIColor blueColor], [UIColor yellowColor],
                           [UIColor orangeColor], [UIColor purpleColor],
                           nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int index = [defaults integerForKey:BACKGROUNDCOLORKEY];
    return colorArray[index];
}

@end
