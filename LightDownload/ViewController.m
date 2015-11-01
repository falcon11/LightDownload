//
//  ViewController.m
//  LightDownload
//
//  Created by starnet on 10/15/15.
//  Copyright © 2015 com.evideo. All rights reserved.
//

#import "ViewController.h"
#import "DownloadService.h"
#import "FilesTableView.h"

@interface ViewController ()<UITextFieldDelegate>
{
    BOOL isFinished;
    DownloadService *_downloadService;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"文件" style:UIBarButtonItemStylePlain target:self action:@selector(openFile)];
    self.title = @"下载";
    _urlText.delegate = self;
    _urlText.text = @"http://dlsw.baidu.com/sw-search-sp/soft/90/25706/QQMusicForMacV2.2.1426490079.dmg";
    isFinished = NO;
    _progressBar.progress = 0.0;
    _progressLabel.text = [NSString stringWithFormat:@"%.1f%%", _progressBar.progress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(IBAction)downLoad:(id)sender
{
    if ([[[_downloadButton titleLabel] text] isEqualToString:@"开始"]) {
        [_downloadButton setTitle:@"暂停" forState:UIControlStateNormal];
        
        if (!_downloadService) {
            __weak typeof(self) weakSelf = self;
            _downloadService = [[DownloadService alloc] initWithErrorBlock:^(NSString *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *tipView = [[UIAlertView alloc] initWithTitle:@"错误" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [tipView show];
                    [_downloadButton setTitle:@"开始" forState:UIControlStateNormal];
                    _progressBar.progress = 0;
                    _progressLabel.text = [[NSString alloc] initWithFormat:@"0%%"];
                });
                
            }completion:^{
                dispatch_async(dispatch_get_main_queue(),^{
                    [weakSelf.downloadButton setTitle:@"已完成" forState:UIControlStateNormal];
                    NSString *urlString = weakSelf.urlText.text;
                    NSString *fileName = [urlString lastPathComponent];
                    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *filePath = [array[0] stringByAppendingPathComponent:fileName];
                    NSString *fileExtension = [filePath pathExtension];
                    if ([fileExtension isEqualToString:@"jpg"] || [fileExtension isEqualToString:@"png"] ) {
                        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
                        UIImage *image = [UIImage imageWithData:imageData];
                        weakSelf.imageView.image = image;
                    }
                });
            }];
            _downloadService.progressBlock = ^(long long currentBytes, long long totalBytes){
                float progress = currentBytes*1.0/totalBytes;
                if (weakSelf)
                {
                    dispatch_async(dispatch_get_main_queue(),^{
                        weakSelf.progressBar.progress = progress;
                        weakSelf.progressLabel.text = [[NSString alloc] initWithFormat:@"%.1f%%",progress*100];
                    });
                }
            };
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_downloadService startWithURL:_urlText.text cacheCapacity:100];
        });
        
    }
    else if([[[_downloadButton titleLabel] text] isEqualToString:@"暂停"])
    {
        
        dispatch_async(dispatch_get_main_queue(),^{
            [_downloadButton setTitle:@"开始" forState:UIControlStateNormal];
        });
        
        if (_downloadService) {
            [_downloadService stop];
            _downloadService = nil;
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [_downloadButton setTitle:@"开始" forState:UIControlStateNormal];
            _progressBar.progress = 0;
            _progressLabel.text = [[NSString alloc] initWithFormat:@"0%%"];
        });
    }
}

- (void)openFile
{
    NSLog(@"openfile............");
    FilesTableView *fileTableView = [[FilesTableView alloc] initWithNibName:@"FilesTableView" bundle:nil];
    //[self presentViewController:fileTableView animated:YES completion:nil];
    [self.navigationController pushViewController:fileTableView animated:YES];
}


@end
