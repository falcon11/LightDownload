//
//  ImageView.m
//  LightDownload
//
//  Created by starnet on 10/26/15.
//  Copyright © 2015 com.evideo. All rights reserved.
//

#import "ImageView.h"

@interface ImageView ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;


@end

@implementation ImageView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageView.image = _image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
