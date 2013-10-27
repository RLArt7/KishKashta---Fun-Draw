//
//  ViewController.m
//  KishKashta
//
//  Created by Harel Avikasis on 04/03/13.ohhhyeeeaaahh
//  Copyright (c) 2013 Harel Avikasis. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ALToastView.h"
#import "Twitter/TWTweetComposeViewController.h"
#import "AppDelegate.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize mainImage;
@synthesize settingsViewController;
@synthesize scrollView;


- (void)viewDidLoad
{

//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    drawArray =[[NSMutableArray alloc]init];
    redoArray =[[NSMutableArray alloc]init];
    [[self scrollView] setMinimumZoomScale:1.0];
    [[self scrollView] setMaximumZoomScale:6.0];
    
    
    
    
    [super viewDidLoad];
    
    
    self.view.multipleTouchEnabled = YES;

}
- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    int count = [allTouches count];
    if(count==1){
    mouseSwiped = YES;
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.view];
        
        CGContextRef ctxt = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(ctxt, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(ctxt, currentPoint.x, currentPoint.y);
        CGContextSetLineCap(ctxt, kCGLineCapRound);
        CGContextSetLineWidth(ctxt, brush );
        CGContextSetRGBStrokeColor(ctxt, red, green, blue, 1.0);
        CGContextSetBlendMode(ctxt,kCGBlendModeNormal);
        
        CGContextStrokePath(ctxt);
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.tempDrawImage setAlpha:opacity];
        
        lastPoint = currentPoint;
    }else if(count==2){
        //        NSLog(@"Number of touches: %i array: %@",count,allTouches);
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewsSwipe:)];
        [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
        [swipe setNumberOfTouchesRequired:2];
        [self.view addGestureRecognizer:swipe];
        
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    UIGraphicsEndImageContext();
    
    if(!mouseSwiped)
    {
        self.tempDrawImage.image = nil;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    [redoArray removeAllObjects];
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [drawArray addObject:UIGraphicsGetImageFromCurrentImageContext()];
    tempImg=UIGraphicsGetImageFromCurrentImageContext();

    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    [self mainImage];
}

/////////////////////origin!///////////////////////////////////////////////////////////////

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//        
//    mouseSwiped = NO;
//    UITouch *touch = [touches anyObject];
//    lastPoint = [touch locationInView:self.view];
//}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSArray *allTouches = [touches allObjects];
//    int count = [allTouches count];
//    if(count==1){
//        mouseSwiped = YES;
//        UITouch *touch = [touches anyObject];
//        CGPoint currentPoint = [touch locationInView:self.view];
//        
//        
//        UIGraphicsBeginImageContext(self.view.frame.size);
//        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
//        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
//        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
//        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
//        
//        
//       
//        CGContextStrokePath(UIGraphicsGetCurrentContext());
//        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
//        [self.tempDrawImage setAlpha:opacity];
//        UIGraphicsEndImageContext();
//        
//        lastPoint = currentPoint;
//    }else if(count==2){
//        //        NSLog(@"Number of touches: %i array: %@",count,allTouches);
//        
//        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewsSwipe:)];
//        [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
//        [swipe setNumberOfTouchesRequired:2];
//        [self.view addGestureRecognizer:swipe];
//        
//    }
//    
//}

- (void)handleViewsSwipe:(UISwipeGestureRecognizer *)gesture{
    
    
    ViewController *view = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    view.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//    NSLog(@"VIEW LOOOOOOOOKKKKKEEEE HEEREEEE: %@",view);
    self.settingsViewController=(SettingsViewController *)view;
    settingsViewController.delegate = self;
    settingsViewController.brush = brush;
    settingsViewController.opacity = opacity;
    settingsViewController.red = red;
    settingsViewController.green = green;
    settingsViewController.blue = blue;
    [self presentViewController:view animated:YES completion:nil];
}



//-(IBAction)zoomIn:(UIPinchGestureRecognizer *)recognizer{

////     NSLog(@"Pinch scale: %f", recognizer.scale);
////    [self viewForZoomingInScrollView:scrollView];
////
////    CGAffineTransform transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
////    if(recognizer.scale<1.0){
////        recognizer.scale=1;
////    }
//////    if(recognizer.scale>5.0){
//////        recognizer.scale=5.0;
//////    }
////    self.myZoomableView.transform = transform;
////    self.tempDrawImage.transform = transform;
//}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    
//    if(!mouseSwiped) {
//        UIGraphicsBeginImageContext(self.view.frame.size);
//        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
//        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
//        CGContextStrokePath(UIGraphicsGetCurrentContext());
//        CGContextFlush(UIGraphicsGetCurrentContext());
//        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
//        
//        UIGraphicsEndImageContext();
//    }
//    [redoArray removeAllObjects];
//    UIGraphicsBeginImageContext(self.mainImage.frame.size);
//    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
//    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
//    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
//    [drawArray addObject:UIGraphicsGetImageFromCurrentImageContext()];
////    NSLog(@"hey im here %i array:%@",[drawArray count],drawArray);
////    tempImg=self.tempDrawImage.image;
//    tempImg=UIGraphicsGetImageFromCurrentImageContext();
//
//    self.tempDrawImage.image = nil;
//    UIGraphicsEndImageContext();
//    
//    [self mainImage];
//}
-(IBAction)undoButtonClicked:(id)sender
{
    
    if([drawArray count]==0 ){
        return;
    }else{
        tempImg=UIGraphicsGetImageFromCurrentImageContext();
        [redoArray addObject:[drawArray lastObject]];
        [drawArray removeLastObject];
        UIGraphicsBeginImageContext(self.mainImage.frame.size);
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        self.mainImage.image = [drawArray lastObject];
        self.tempDrawImage.image = nil;
        UIGraphicsEndImageContext();
        
        [self mainImage];
    }
}
-(IBAction)redoButtonClicked:(id)sender{
    if([redoArray count]==0 ){
        return;
    }else{
        [drawArray addObject:[redoArray lastObject]];
        
        UIGraphicsBeginImageContext(self.mainImage.frame.size);
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        self.mainImage.image = [redoArray lastObject];
        [redoArray removeLastObject];
        self.tempDrawImage.image = nil;
        UIGraphicsEndImageContext();
        
        [self mainImage];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    SettingsViewController * settingsVC = (SettingsViewController *)segue.destinationViewController;
    settingsVC.delegate = self;
    settingsVC.brush = brush;
    settingsVC.opacity = opacity;
    settingsVC.red = red;
    settingsVC.green = green;
    settingsVC.blue = blue;
    
}
- (void)closeSettings:(id)sender {
    

    red = ((SettingsViewController*)sender).red;
    green = ((SettingsViewController*)sender).green;
    blue = ((SettingsViewController*)sender).blue;
    brush = ((SettingsViewController*)sender).brush;
    opacity = ((SettingsViewController*)sender).opacity;
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)save:(id)sender {
    
    
//    NSArray *activityItems;
    
    UIGraphicsBeginImageContextWithOptions(mainImage.bounds.size, NO,0.0);
    [mainImage.image drawInRect:CGRectMake(0, 0, mainImage.frame.size.width, mainImage.frame.size.height)];
    UIImage *savedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//        activityItems = @[@"Check out this drawing I made in the new app KishKashta",savedImage ];

//    UIActivityViewController *activityController =
//    [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
//    activityController.excludedActivityTypes=@[UIActivityTypeAssignToContact,UIActivityTypePrint,UIActivityTypePostToWeibo];
//    
//    [self presentViewController:activityController
//                       animated:YES completion:nil];
//    [activityController setCompletionHandler:^(NSString *act, BOOL done){
//        NSString *ServiceMsg = nil;
//        if ( [act isEqualToString:UIActivityTypeMail] )           ServiceMsg = @"Mail was sent!";
//        if ( [act isEqualToString:UIActivityTypePostToTwitter] )  ServiceMsg = @"Posted on twitter";
//        if ( [act isEqualToString:UIActivityTypePostToFacebook] ) ServiceMsg = @"Posted on facebook";
//        if ( [act isEqualToString:UIActivityTypeMessage] )        ServiceMsg = @"SMS was sent!";
//        if ( [act isEqualToString:UIActivityTypeAirDrop] )        ServiceMsg = @"The Image Arrived!";
//        if ( [act isEqualToString:UIActivityTypeSaveToCameraRoll]) ServiceMsg = @"Image Saved";
//        if ( done )
//            {
//                toastInView:withText:[ALToastView toastInView:self.view withText:ServiceMsg];
//            }
//    }];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString * jpgPath = [documentsDirectory stringByAppendingPathComponent:@"KishKashtaDraw.png"];
    NSData *imageData = UIImageJPEGRepresentation(savedImage, 0.8);
    [imageData writeToFile:jpgPath atomically:YES];
    NSURL *url = [NSURL fileURLWithPath:jpgPath];
    
    self.dic = [UIDocumentInteractionController interactionControllerWithURL: url];
//    [self.dic retain];

    self.dic.delegate = self;
    [self.dic presentOptionsMenuFromRect:CGRectZero inView:self.view animated:YES];
    
    




}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 21) {
        if (buttonIndex == 0){
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                UIImagePickerController *imagePicker= [[UIImagePickerController alloc] init];
                imagePicker.delegate=self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.mediaTypes =[NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
                imagePicker.allowsEditing= YES;
                
                [self presentViewController:imagePicker animated:YES completion:nil];
                newMedia=YES;
            }
        }
        if (buttonIndex == 1){
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
                imagePicker.delegate= self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.mediaTypes =[NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
                imagePicker.allowsEditing = NO;
                [self presentViewController:imagePicker animated:YES completion:nil];
                newMedia = NO;
            }
        }
    }
}

- (void) useCamera
{
    UIActionSheet *actionSheet2 = [[UIActionSheet alloc] initWithTitle:@""
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Take Photo", @"Choose Existing", @"Cancel", nil];
    actionSheet2.tag=21;
    [actionSheet2 showInView:self.view];
}



-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        self.tempDrawImage.image=mainImage.image;
        mainImage.image = image;
        
        
        UIGraphicsBeginImageContext(self.mainImage.frame.size);
        //        [drawArray addObject:self.tempDrawImage.image];
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
        self.tempDrawImage.image=nil;
        UIGraphicsEndImageContext();




        [drawArray addObject:mainImage.image];
//        [drawArray addObject:mainImage.image];
        if (self.tempDrawImage.image==nil) {
            
        }else{
//            [drawArray addObject:self.tempDrawImage.image];
//            [drawArray addObject:self.tempDrawImage.image];

        }

        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
}
-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)reset:(id)sender{
    if(self.tempDrawImage.image!=nil){
        UIGraphicsBeginImageContext(self.mainImage.frame.size);
//        [drawArray addObject:self.tempDrawImage.image];
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
        [drawArray addObject:self.mainImage.image];
        [drawArray addObject:self.mainImage.image];
//        self.tempDrawImage.image = nil;
        UIGraphicsEndImageContext();
//        [drawArray addObject:drawArray.lastObject];
        self.mainImage.image =nil;
        self.tempDrawImage.image=nil;

    }else{
        if(self.mainImage.image !=nil){
        [drawArray addObject:self.mainImage.image];
        [drawArray addObject:self.mainImage.image];
        self.mainImage.image =nil;
        self.tempDrawImage.image=nil;
        }else{
            return;
        }
    }

}

@end
