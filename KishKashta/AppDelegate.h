//
//  AppDelegate.h
//  KishKashta
//
//  Created by Harel Avikasis on 04/03/13.
//  Copyright (c) 2013 Harel Avikasis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController  *navigationController;
@property (nonatomic, retain) ViewController   *viewController;

@end
