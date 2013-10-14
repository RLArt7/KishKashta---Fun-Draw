//
//  SettingsViewController.m
//  KishKashta
//
//  Created by Harel Avikasis on 05/03/13.
//  Copyright (c) 2013 Harel Avikasis. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewController.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize brushControl;
@synthesize opacityControl;
@synthesize brushPreview;
@synthesize opacityPreview;
@synthesize brushValueLabel;
@synthesize opacityValueLabel;
@synthesize brush;
@synthesize opacity;
@synthesize delegate;
@synthesize red;
@synthesize green;
@synthesize blue;

@synthesize colorPatch;
@synthesize colorPicker;
@synthesize brightnessSlider;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    [super viewDidLoad];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if (iOSDeviceScreenSize.height == 568){
            
            
            
            colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(45.0, 220, 230, 230)];
            [colorPicker setCropToCircle:YES]; // Defaults to YES (and you can set BG color)
            [colorPicker setBackgroundColor:NULL];
            [colorPicker setDelegate:self];
            // View that controls brightness
            brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(10,155,200,30)];
            [brightnessSlider setColorPicker:colorPicker];
            [self.view addSubview:brightnessSlider];
            [self.view addSubview:colorPicker];
        }
        else{
            
            
            colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(55.0, 190, 200, 200)];
            [colorPicker setCropToCircle:YES]; // Defaults to YES (and you can set BG color)
            [colorPicker setBackgroundColor:NULL];
            [colorPicker setDelegate:self];
            // View that controls brightness
            brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(10,155,200,30)];
            [brightnessSlider setColorPicker:colorPicker];
            [self.view addSubview:brightnessSlider];
            [self.view addSubview:colorPicker];
        }
    }else{
        colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(158, 489, 450, 450)];
        [colorPicker setCropToCircle:YES]; // Defaults to YES (and you can set BG color)
        [colorPicker setBackgroundColor:NULL];
        [colorPicker setDelegate:self];
        // View that controls brightness
        brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(25,450,200,30)];
        [brightnessSlider setColorPicker:colorPicker];
        [self.view addSubview:brightnessSlider];
        [self.view addSubview:colorPicker];
    }
    
    
    

	
    
    // On/off circle or square
//    UISwitch *circleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 150, 0, 0)];
//    [circleSwitch setOn:colorPicker.cropToCircle];
//	[circleSwitch addTarget:self action:@selector(circleSwitchAction:) forControlEvents:UIControlEventValueChanged];
//	[self.view addSubview:circleSwitch];
        
    // View that shows selected color
//	colorPatch = [[UIView alloc] initWithFrame:CGRectMake(220, 150, 150, 30.0)];
//	[self.view addSubview:colorPatch];
	// Do any additional setup after loading the view.
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
//    [banner accessibilityViewIsModal];
    [UIView commitAnimations];
    
}
-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
    
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)colorPickerDidChangeSelection:(RSColorPickerView *)cp
{
    brightnessSlider.value = [cp brightness];
    CGColorRef color=[[cp selectionColor]CGColor];
    int numOfCom=CGColorGetNumberOfComponents(color);
    if(numOfCom==4){
        const CGFloat *compo=CGColorGetComponents(color);
        self.red=compo[0];
        self.green=compo[1];
        self.blue=compo[2];
    }
    UIGraphicsBeginImageContext(self.opacityPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.opacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.opacityPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)viewDidUnload
{
    [self setBrushControl:nil];
    [self setOpacityControl:nil];
    [self setBrushPreview:nil];
    [self setOpacityPreview:nil];
    [self setBrushValueLabel:nil];
    [self setOpacityValueLabel:nil];
       [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeSettings:(id)sender {
    [self.delegate closeSettings:self];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sliderChanged:(id)sender {
    UISlider * changedSlider = (UISlider*)sender;
    
    if(changedSlider == self.brushControl) {
        
        self.brush = self.brushControl.value;
        self.brushValueLabel.text = [NSString stringWithFormat:@"%.1f", self.brush];
        
    } else if(changedSlider == self.opacityControl) {
        
        self.opacity = self.opacityControl.value;
        self.opacityValueLabel.text = [NSString stringWithFormat:@"%.1f", self.opacity];
    }

    UIGraphicsBeginImageContext(self.opacityPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.opacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.opacityPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
}
- (void)viewWillAppear:(BOOL)animated {
    
    // ensure the values displayed are the current values
    
    [colorPicker setSelectionColor:[UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1]];
    self.brushControl.value = self.brush;
    [self sliderChanged:self.brushControl];
    
    self.opacityControl.value = self.opacity;
    [self sliderChanged:self.opacityControl];
    
}
- (void) viewWillDisappear:(BOOL)animated{
    [self.delegate closeSettings:self];
}
- (void) viewdidDisappear:(BOOL)animated{
    [self.delegate closeSettings:self];
}

- (IBAction)pencilPressed:(id)sender {
    UIButton * PressedButton = (UIButton*)sender;
    
    switch(PressedButton.tag)
    {
        case 0:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            [colorPicker setSelectionColor:[UIColor blackColor]];
            break;
        case 1:
            red = 105.0/255.0;
            green = 105.0/255.0;
            blue = 105.0/255.0;
            [colorPicker setSelectionColor:[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1]];
//            [colorPicker setSelectionColor:[UIColor grayColor]];
            break;
        case 2:
            red = 255.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            [colorPicker setSelectionColor:[UIColor redColor]];
            break;
        case 3:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 255.0/255.0;
            [colorPicker setSelectionColor:[UIColor blueColor]];
            break;
        case 4:
            red = 102.0/255.0;
            green = 204.0/255.0;
            blue = 0.0/255.0;
            [colorPicker setSelectionColor:[UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1]];
            break;
        case 5:
            red = 102.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            [colorPicker setSelectionColor:[UIColor greenColor]];
            break;
        case 6:
            red = 51.0/255.0;
            green = 204.0/255.0;
            blue = 255.0/255.0;
            [colorPicker setSelectionColor:[UIColor colorWithRed:51.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:1]];
            break;
        case 7:
            red = 160.0/255.0;
            green = 82.0/255.0;
            blue = 45.0/255.0;
            [colorPicker setSelectionColor:[UIColor colorWithRed:160.0/255.0 green:82.0/255.0 blue:45.0/255.0 alpha:1]];
            break;
        case 8:
            red = 255.0/255.0;
            green = 102.0/255.0;
            blue = 0.0/255.0;
            [colorPicker setSelectionColor:[UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:0.0/255.0 alpha:1]];
            break;
        case 9:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            [colorPicker setSelectionColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1]];
            break;
    }
}

- (IBAction)eraserPressed:(id)sender {
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    opacity = 1.0;
    [colorPicker setSelectionColor:[UIColor whiteColor]];
}


@end
