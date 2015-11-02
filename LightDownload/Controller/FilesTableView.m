//
//  FilesTableView.m
//  LightDownload
//
//  Created by starnet on 10/25/15.
//  Copyright © 2015 com.evideo. All rights reserved.
//

#import "FilesTableView.h"
#import "ImageView.h"
#import "MusicView.h"
#import "VideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface FilesTableView()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dataSource;
}
@property (nonatomic, strong)AVAudioPlayer *player;

@end

@implementation FilesTableView

- (void)viewDidLoad
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSMutableArray *allFile = [[NSFileManager defaultManager] directoryContentsAtPath:array[0]];
    _dataSource = allFile;
    self.title = @"文件";
    //self.navigationItem.leftBarButtonItem.title = @"返回";
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp3"];
    NSLog(@"filepath:%@...............", filePath);
    //[self playMusic:filePath];
    VideoView *videoView = [[VideoView alloc] init];
    [self.navigationController pushViewController:videoView animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellStyle = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStyle];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyle];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    //NSString *type = [_dataSource[indexPath.row] pathExtension];
    //NSLog(@"type:%@..................", type);
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [array[0] stringByAppendingPathComponent:_dataSource[indexPath.row]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"filepath%@..........", filePath);
    NSError *error;
    if ([fileManager fileExistsAtPath:filePath]) {
        NSLog(@"file exits...........");
    }
    else
    {
        NSLog(@"file doesn't exits...........");
    }
    if ([fileManager isDeletableFileAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:&error];
        [_dataSource removeObjectAtIndex: indexPath.row];
        NSLog(@"delete file................1");
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"delete file................2");
    }
    else
    {
        NSLog(@"can't delete.................");
    }
    //[tableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [array[0] stringByAppendingPathComponent:_dataSource[indexPath.row]];
    NSString *type = [_dataSource[indexPath.row] pathExtension];
    if ([type isEqualToString:@"jpg"] || [type isEqualToString:@"png"] || [type isEqualToString:@"bmp"]) {
        ImageView *imageView = [[ImageView alloc] init];
        //NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        imageView.image = [UIImage imageWithContentsOfFile:filePath];
        //[self presentViewController:imageView animated:YES completion:nil];
        [self.navigationController pushViewController:imageView animated:YES];
    }
    else if([type isEqualToString:@"mp3"] || [type isEqualToString:@"wav"])
    {
        //[self playMusic:filePath];
        MusicView *musicView = [[MusicView alloc] init];
        musicView.musicPath = filePath;
        [self.navigationController pushViewController:musicView animated:YES];
    }
    else
    {
        VideoView *videoView = [[VideoView alloc] init];
        [self.navigationController pushViewController:videoView animated:YES];
    }
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playMusic:(NSString *)filePath
{
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: filePath];
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    _player = newPlayer;
    [newPlayer prepareToPlay];
    [newPlayer play];
}


@end
