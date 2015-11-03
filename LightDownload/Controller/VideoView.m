//
//  VideoViewViewController.m
//  LightDownload
//
//  Created by starnet on 11/2/15.
//  Copyright © 2015 com.evideo. All rights reserved.
//

#import "VideoView.h"
#import "PlayerSetting.h"

@interface VideoView ()

@end

@implementation VideoView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addObserver
{
    //监听播放器网络缓存状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.controller.moviePlayer];
    
    //监听播放器结束状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.controller.moviePlayer];
    
    //监听准备播放状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaIsPreParedToPlayDidChange:) name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.controller.moviePlayer];
    
    //监听播放器播放状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.controller.moviePlayer];
}

- (void)addSetting
{
    MPMovieScalingMode scalingMode = [PlayerSetting scalingMode];
    self.controller.moviePlayer.scalingMode = scalingMode;
    
    MPMovieControlStyle controlStyle = [PlayerSetting controlStyle];
    self.controller.moviePlayer.controlStyle = controlStyle;
    
    UIColor *color = [PlayerSetting backgroundColor];
    self.controller.moviePlayer.backgroundView.backgroundColor = color;
}

- (void)createPlayer:(NSString *)path
{
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    self.controller = moviePlayerController;
    [self addObserver];
    [self addSetting];
    [[self.controller view] setFrame:self.videoBackgroundView.bounds];
    [self.videoBackgroundView addSubview:self.controller.view];
    [self.controller.moviePlayer play];
}

-(IBAction)play:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    [self createPlayer:path];
}

#pragma mark -

- (void)loadStateDidChange:(NSNotification *)notification
{
    NSLog(@"............loadStateDidChange");
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if ([reason intValue] == MPMovieFinishReasonPlaybackEnded) {
        NSLog(@"MPMovieFinishReasonPlaybackEnded");     //播放结束
    }
    else if ([reason intValue] == MPMovieFinishReasonPlaybackError)
    {
        NSLog(@"MPMovieFinishReasonPlaybackError");     //播放错误
    }
    else if([reason intValue] == MPMovieFinishReasonUserExited)
    {
        NSLog(@"MPMovieFinishReasonUserExited");    //退出播放
    }
    [self.controller.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)mediaIsPreParedToPlayDidChange:(NSNotification *)notification
{
    NSLog(@"playbackIsPreparedToPlayDidChange");
}

- (void)moviePlayBackStateDidChange:(NSNotification *)notification
{
    MPMoviePlayerController *player = notification.object;
    if (player.playbackState == MPMoviePlaybackStateStopped) {
        self.label.text = @"播放已停止";
        NSLog(@"播放停止");
    }
    else if(player.playbackState == MPMoviePlaybackStatePlaying)
    {
        self.label.text = @"正在播放";
        NSLog(@"正在播放");
    }
    else if(player.playbackState == MPMoviePlaybackStatePaused)
    {
        self.label.text = @"暂停";
        NSLog(@"暂停");
    }
    else if (player.playbackState == MPMoviePlaybackStateInterrupted)
    {
        self.label.text = @"播放中断";
        NSLog(@"播放中断");
    }
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
