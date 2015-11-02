//
//  MusicView.m
//  LightDownload
//
//  Created by starnet on 11/2/15.
//  Copyright © 2015 com.evideo. All rights reserved.
//

#import "MusicView.h"
#import <AVFoundation/AVFoundation.h>

@interface MusicView ()
{
    int time;
}

@property (nonatomic, strong)AVAudioPlayer *player;
@property (nonatomic, weak) IBOutlet UIButton *readyButton;
@property (nonatomic, weak) IBOutlet UILabel *tipLabel;


@end

@implementation MusicView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action:(id)sender
{
    if (!_musicPath) {
        return;
    }
    if (self.player.playing) {
        if ([self.readyButton.titleLabel.text isEqualToString:@"暂停"]) {
            time = self.player.currentTime;
            [self.readyButton setTitle:@"继续" forState:UIControlStateNormal];
            self.tipLabel.text = @"已暂停";
            [self.player pause];
        }
    }
    else
    {
        if ([self.readyButton.titleLabel.text isEqualToString:@"开始"] ||
            [self.readyButton.titleLabel.text isEqualToString:@"继续"] ||
            [self.readyButton.titleLabel.text isEqualToString:@"结束"]) {
            NSLog(@"%d..............", time);
            
            [self.readyButton setTitle:@"暂停" forState:UIControlStateNormal];
            self.tipLabel.text = @"播放中";
            [self playMusic];
        }
    }
}



- (void)playMusic
{
    NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:_musicPath];
    if (self.player == nil) {
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
        self.player = player;
        self.player.delegate = self;
    }
    [self.player prepareToPlay];
    if (time > 0) {
        [self.player playAtTime:time];
    }
    else
    {
        [self.player play];
    }
}

#pragma mark -
#pragma AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.player == player && flag) {
        [self.readyButton setTitle:@"结束" forState:UIControlStateNormal];
        self.tipLabel.text = @"已结束";
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedFailureReason message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
