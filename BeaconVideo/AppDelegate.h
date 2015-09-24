//
//  AppDelegate.h
//  BeaconVideo
//
//  Created by Jovonni Pharr on 8/23/14.
//  Copyright (c) 2014 Nuracode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)isProximityEnabled;

@end
