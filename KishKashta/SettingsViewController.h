//
//  SettingsViewController.h
//  KishKashta
//
//  Created by Harel Avikasis on 05/03/13.
//  Copyright (c) 2013 Harel Avikasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSColorPickerView.h"
#import "RSBrightnessSlider.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <iAd/iAd.h>


@protocol SettingsViewControllerDelegate <NSObject>//,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
    

- (void)closeSettings:(id)sender;
@end

@interface SettingsViewController : UIViewController<RSColorPickerViewDelegate,ADBannerViewDelegate>{

}
@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;

@property (weak, nonatomic) IBOutlet UILabel *brushValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *opacityValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *brushControl;
@property (weak, nonatomic) IBOutlet UISlider *opacityControl;
@property (weak, nonatomic) IBOutlet UIImageView *brushPreview;
@property (weak, nonatomic) IBOutlet UIImageView *opacityPreview;

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;
- (IBAction)pencilPressed:(id)sender;
- (IBAction)eraserPressed:(id)sender;
//- (IBAction)reset:(id)sender;

@property CGFloat brush;
@property CGFloat opacity;

- (IBAction)closeSettings:(id)sender;
- (IBAction)sliderChanged:(id)sender;



@property (nonatomic) RSColorPickerView *colorPicker;
@property (nonatomic) RSBrightnessSlider *brightnessSlider;
@property (nonatomic) UIView *colorPatch;



@end
