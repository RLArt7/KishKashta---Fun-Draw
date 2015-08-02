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

NSInteger sort(id a, id b, void *reverse) {
    return [a compare:b options:NSNumericSearch];
}

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
    
//    self.mainImage.image=[UIImage imageNamed:@"WhitePage.png"];
//    [drawArray addObject:self.mainImage.image];
    
    [[self scrollView] setMinimumZoomScale:1.0];
    [[self scrollView] setMaximumZoomScale:6.0];
    
    
    [ViewController clearTmpDirectory];
    
    [super viewDidLoad];
    
    
    self.view.multipleTouchEnabled = YES;

}
+ (void)clearTmpDirectory
{
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
    const CGFloat margin = 40.0f;
    CGSize size = CGSizeMake([source size].width + 2*margin, [source size].height + 2*margin);
    UIGraphicsBeginImageContext(size);
    
    [[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)] fill];
    
    CGRect rect = CGRectMake(margin, margin, size.width-2*margin, size.height-2*margin);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
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
    
    UIActionSheet *actionSheet2 = [[UIActionSheet alloc] initWithTitle:@""
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Share Photo", @"Share Video", @"Cancel", nil];
    actionSheet2.tag=11;
    [actionSheet2 showInView:self.view];
    
    
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
    if(actionSheet.tag==11){
        if (buttonIndex == 0){
            UIGraphicsBeginImageContextWithOptions(mainImage.bounds.size, NO,0.0);
            [mainImage.image drawInRect:CGRectMake(0, 0, mainImage.frame.size.width, mainImage.frame.size.height)];
            UIImage *savedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            
            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString * jpgPath = [documentsDirectory stringByAppendingPathComponent:@"KishKashtaDraw.png"];
            NSData *imageData = UIImageJPEGRepresentation(savedImage, 0.8);
            [imageData writeToFile:jpgPath atomically:YES];
            NSURL *url = [NSURL fileURLWithPath:jpgPath];
            
            self.dic = [UIDocumentInteractionController interactionControllerWithURL: url];
            
            self.dic.delegate = self;
            [self.dic presentOptionsMenuFromRect:CGRectZero inView:self.view animated:YES];
        }
        if (buttonIndex==1){
            [self createVideo:self];
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
//        self.mainImage.image=[UIImage imageNamed:@"WhitePage.png"];
//        [drawArray addObject:self.mainImage.image];

    }else{
        if(self.mainImage.image !=nil){
        [drawArray addObject:self.mainImage.image];
        [drawArray addObject:self.mainImage.image];
        self.mainImage.image =nil;
        self.tempDrawImage.image=nil;
//        self.mainImage.image=[UIImage imageNamed:@"WhitePage.png"];
//        [drawArray addObject:self.mainImage.image];
        }else{
            return;
        }
    }
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"movie.mp4"];
    [self clearTmp:path];
}


- (void)writeImageAsMovie:(NSArray *)array toPath:(NSString*)path size:(CGSize)size duration:(int)duration
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];

    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path]
                                                           fileType:AVFileTypeMPEG4
                                                              error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   nil];
    AVAssetWriterInput* writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                          outputSettings:videoSettings];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                                                                     sourcePixelBufferAttributes:nil];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];
    
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer = NULL;
    buffer = [self pixelBufferFromCGImage:[[array objectAtIndex:0] CGImage]];
    CVPixelBufferPoolCreatePixelBuffer (NULL, adaptor.pixelBufferPool, &buffer);
    
    [adaptor appendPixelBuffer:buffer withPresentationTime:kCMTimeZero];
    int i = 1;
    while (1)
    {
		if(writerInput.readyForMoreMediaData){
            
			CMTime frameTime = CMTimeMake(1, 10 );
			CMTime lastTime=CMTimeMake(i, 10);
			CMTime presentTime=CMTimeAdd(lastTime, frameTime);
			
			if (i >= [array count])
			{
				buffer = NULL;
			}
			else
			{
				buffer = [self pixelBufferFromCGImage:[[array objectAtIndex:i] CGImage]];
			}
			
			
			if (buffer)
			{
				// append buffer
				[adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
				i++;
			}
			else
			{
				
				//Finish the session:
				[writerInput markAsFinished];
//				[videoWriter finishWriting];
                [videoWriter finishWritingWithCompletionHandler:^{
                    CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
                    
                }];

				
				CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
				
				NSLog (@"Done");
				break;
			}
		}
    }
    CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
}



- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image
{

    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                         [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    

    CVPixelBufferCreate(kCFAllocatorDefault, CGImageGetWidth(image),
                        CGImageGetHeight(image), kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                        &pxbuffer);
    
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, self.mainImage.frame.size.width,
                                                 self.mainImage.frame.size.height, 8, 4*self.mainImage.frame.size.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}




- (IBAction)createVideo:(id)sender {
    if([drawArray count]<30){
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Short Draw" message:@"The Video is less then 1.0 sec" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        

        NSMutableArray *nameArray=[[NSMutableArray alloc]init];
        NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"movie.mp4"];
        
        NSArray *array=[self copyArray:drawArray];

        for(int i=0;i<array.count;i++){
            if ([array objectAtIndex:i])
                {
                    [UIImagePNGRepresentation([array objectAtIndex:i]) writeToFile:[NSTemporaryDirectory()    stringByAppendingFormat:@"%d.png",i] atomically:YES];
                    NSString *pathName = [NSTemporaryDirectory() stringByAppendingFormat:@"%d.png",i];
                    UIImage *imgi=[UIImage imageWithContentsOfFile:pathName];
                    if(imgi){
                        [nameArray addObject:imgi];
                    }
                }
        }
        NSArray *refArray=[self copyArray:nameArray];
        [self writeImageAsMovie:refArray toPath:path size:CGSizeMake(self.mainImage.frame.size.width,self.mainImage.frame.size.height ) duration:1];
        for(int i=0;i<array.count;i++){
                if ([array objectAtIndex:i])
                {
                    NSString *pathName = [NSTemporaryDirectory() stringByAppendingFormat:@"%d.png",i];
                    [[NSFileManager defaultManager] removeItemAtPath:pathName error:nil];
                }
        }
        NSURL *pathURL=[NSURL fileURLWithPath:path];
        [self saveVideo:pathURL];
    }
}
-(void)saveVideo:(NSURL *)pathUrl{
    self.dic2 = [UIDocumentInteractionController interactionControllerWithURL: pathUrl];
    self.dic2.delegate = self;
    [self.dic2 presentOptionsMenuFromRect:CGRectZero inView:self.view animated:YES];
}

-(NSArray *)copyArray:(NSMutableArray*)mutableArray{
    NSArray *array=[NSArray arrayWithArray:mutableArray];
    return array;
    
}
-(UIImage *)getFirstImage:(NSMutableArray*)mutableArray{
    UIImage *image=[mutableArray objectAtIndex:0];
   
    
    return image;
    
}
-(void)clearTmp:(NSString *)pathToClean{
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathToClean])
        [[NSFileManager defaultManager] removeItemAtPath:pathToClean error:nil];
}

@end
