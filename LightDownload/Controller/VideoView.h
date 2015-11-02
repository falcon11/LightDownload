//
//  VideoViewViewController.h
//  LightDownload
//
//  Created by starnet on 11/2/15.
//  Copyright © 2015 com.evideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoView : UIViewController

@property (nonatomic, weak) IBOutlet UIView *videoBackgroundView;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, strong) MPMoviePlayerViewController *controller;

- (IBAction)play:(id)sender;
@end
