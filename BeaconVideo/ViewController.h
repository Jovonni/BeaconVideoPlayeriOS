//
//  ViewController.h
//  BeaconVideo
//
//  Created by Jovonni Pharr on 8/23/14.
//  Copyright (c) 2014 Nuracode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FYX/FYX.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController <FYXServiceDelegate> {
    MPMoviePlayerController *moviePlayer;
    IBOutlet UILabel *distance;
    IBOutlet UILabel *beaconName;
    IBOutlet UIWebView *webview;
}

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;



@end
