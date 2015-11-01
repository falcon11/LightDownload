//
//  ViewController.h
//  LightDownload
//
//  Created by starnet on 10/15/15.
//  Copyright © 2015 com.evideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *urlText;
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIProgressView *progressBar;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
//@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
//@property (nonatomic, weak) IBOutlet UIButton *rightItem;

- (IBAction)downLoad:(id)sender;
- (IBAction)openFile;


@end

