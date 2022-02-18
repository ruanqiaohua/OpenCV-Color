//
//  ViewController.m
//  OpenCV-Color
//
//  Created by 阮巧华 on 2019/12/9.
//  Copyright © 2019 阮巧华. All rights reserved.
//

#import "ViewController.h"
#import "OpenCVImageTool.h"
#import "UIImage+FixOrientation.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *inputImageView;

@property (nonatomic, weak) IBOutlet UIImageView *outputImageView;

@property (nonatomic, strong) UIImage *image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Action

- (IBAction)inputImageViewTap:(UITapGestureRecognizer *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    [self showDetailViewController:picker sender:nil];
}

- (IBAction)repayRedButtonAction:(UIButton *)sender {
    
    if (!_inputImageView.image) return;

    UIImage *image = [OpenCVImageTool addLightImage:_inputImageView.image];
    _outputImageView.image = image;
}

- (IBAction)repayBlueButtonAction:(UIButton *)sender {
    
    if (!_inputImageView.image) return;

    UIImage *image = [OpenCVImageTool addHstackImage:_inputImageView.image];
    _outputImageView.image = image;
}

- (IBAction)grayButtonAction:(UIButton *)sender {
    
    if (!_inputImageView.image) return;

    UIImage *image = [OpenCVImageTool getGrayImage:_inputImageView.image];
    _outputImageView.image = image;
}

- (IBAction)blackWhiteButtonAction:(UIButton *)sender {
    
    if (!_inputImageView.image) return;

    UIImage *image = [OpenCVImageTool getBlackWhiteImage:_inputImageView.image];
    _outputImageView.image = image;
}

- (IBAction)rectangleBtnClick:(id)sender {
    
    if (!_inputImageView.image) return;

    _outputImageView.image = _image;

    NSArray *points = [OpenCVImageTool getRectanglePoints:_image];
    
    for (NSString *value in points) {
        CGPoint point = CGPointFromString(value);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        CGFloat scaleX = _inputImageView.frame.size.width / _inputImageView.image.size.width;
        CGFloat scaleY = _inputImageView.frame.size.height / _inputImageView.image.size.height;
        btn.center = CGPointMake(point.x * scaleX, point.y * scaleY);
        [_outputImageView addSubview:btn];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        _image = [image fixOrientation];
        _inputImageView.image = _image;
    }
}

@end
