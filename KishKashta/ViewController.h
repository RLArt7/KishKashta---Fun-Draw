//
//  ViewController.h
//  KishKashta
//
//  Created by Harel Avikasis on 04/03/13.
//  Copyright (c) 2013 Harel Avikasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <Social/Social.h>


@interface ViewController : UIViewController <SettingsViewControllerDelegate,UIScrollViewDelegate, UIActionSheetDelegate
,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    
    SettingsViewController *settingsViewController;
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    BOOL newMedia;
    UIImage *tempImg;
    NSMutableArray *drawArray;
    NSMutableArray *redoArray;
    
    
}

@property (nonatomic,retain) NSUndoManager *undoManager;


@property (nonatomic, retain) SettingsViewController *settingsViewController;



@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)save:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)useCamera;

-(IBAction)redoButtonClicked:(id)sender;





@end
