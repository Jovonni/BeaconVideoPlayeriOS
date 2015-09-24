//
//  ViewController.m
//  BeaconVideo
//
//  Created by Jovonni Pharr on 8/23/14.
//  Copyright (c) 2014 Nuracode. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXTransmitter.h>


@interface ViewController () {
    BOOL isVideoPlaying;
    BOOL isAskerOpen;
    NSString *stringURL;
    NSString *chosenBeacon;
}


@property (nonatomic) FYXVisitManager *visitManager;


@end


@implementation ViewController


@synthesize moviePlayer;

- (void)serviceStarted
{
    // this will be invoked if the service has successfully started
    // bluetooth scanning will be started at this point.
    NSLog(@"FYX Service Successfully Started");
}

- (void)startServiceFailed:(NSError *)error
{
    // this will be called if the service has failed to start
    NSLog(@"%@", error);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [FYX startService:self];
    
    self.visitManager = [FYXVisitManager new];
    self.visitManager.delegate = self;
    [self.visitManager start];
    
    isVideoPlaying = NO;
    isAskerOpen = NO;
    
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"]];
    
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
    

    
}

-(void)changeDistanceLabel: (int)value{
    
    //for test
    [distance setText:[NSString stringWithFormat:@"Distance: %i",value]];
    
}

-(void)changeBeaconName: (NSString *)name{
    
    //for test
    [beaconName setText:name];
    
}

- (void)didArrive:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter is sighted for the first time
    NSLog(@"I arrived at a Gimbal Beacon!!! %@", visit);
}
- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
    // this will be invoked when an authorized transmitter is sighted during an on-going visit
    
    //NSLog(@"I received a sighting!!! %@", visit.transmitter.name);
    //NSLog(@"visit: %@", visit);
    //NSLog(@"RSSI: %@", RSSI);
    
    //[self changeDistanceLabel:[RSSI intValue]];
    //[self changeBeaconName:visit.transmitter.name];
    
    
                    if([RSSI intValue] > -70){
        
                        chosenBeacon = visit.transmitter.name;
                        
                        [self askUserIfWantToView];
        
                    }
    
    
    
}

- (BOOL)isProximityEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"fyx_service_started_key"];
}

- (void)didDepart:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter has not been sighted for some time
    NSLog(@"I left the proximity of a Gimbal Beacon!!!! %@", visit.transmitter.name);
    NSLog(@"I was around the beacon for %f seconds", visit.dwellTime);
}

-(BOOL)playTheVideo: (int)vid{
    
    
    NSLog(@"Playing video: %i", vid);
    
    ////--------------TO CHANGE THE VIDEO URL---------/////////
    //NSURL* url = [NSURL URLWithString:@"http://clearimedia.co/img/Adobe%20and%20Wired%20Introduce%20a%20New%20Digital%20Magazine%20Experience.mp4"];
    
    
    
    if(vid == 1){
        stringURL = @"http://code.nuracodedev.com/beacon/media/hebru_brantley_street_art.mp4";
    }else if(vid == 2){
        stringURL = @"http://code.nuracodedev.com/beacon/media/art_basel_aaron_maybin.mp4";
    }else if(vid == 3){
        stringURL = @"http://code.nuracodedev.com/beacon/media/jean_michel_basquiat.mp4";
    }
    
    NSLog(@"%@", stringURL);
    
    NSURL *url= [NSURL URLWithString:stringURL];
    
    
    /*
     NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
     pathForResource:@"MOVIE" ofType:@"MOV"]];
     */
    moviePlayer =  [[MPMoviePlayerController alloc]
                    initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:moviePlayer];

    
    moviePlayer.controlStyle = MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];
    


    
    
    return YES;
}

-(void)askUserIfWantToView{
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Wait"
                          message:@"Would you like to view the content?"
                          delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil];
    
    if(isAskerOpen == YES){
        
    }else{
        [alert show];
        isAskerOpen = YES;
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0){
        //delete it
        NSLog(@"No Video");
        isAskerOpen = NO;
        
    }else{
        NSLog(@"Yes Video");
        
        if(isVideoPlaying == YES){
            NSLog(@"Video Already Playing");
        }else{
            
            
            isVideoPlaying = YES;
            
            
            if([chosenBeacon isEqualToString:@"t1"]){
                [self playTheVideo:1];
            }else if([chosenBeacon isEqualToString:@"t2"]){
                [self playTheVideo:2];
            }else if([chosenBeacon isEqualToString:@"t3"]){
                [self playTheVideo:3];
            }
            
            
            
        }
        
    }
    
    
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    NSLog(@"Closing");
    
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"Playback Ended");
            break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"Playback Error");
            break;
        case MPMovieFinishReasonUserExited:
            NSLog(@"User Exited");
            break;
        default:
            break;
    }
    
    
    MPMoviePlayerController *player = [notification object];
    
    
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    
    
    isVideoPlaying = NO;
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
    
}

-(void)doneButtonClick:(NSNotification*)notification{
    
    //NSNumber *reason = [notification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    NSLog(@"Closed reason: %@", notification);
    
    isVideoPlaying = NO;
    isAskerOpen = NO;

}


////originals



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
