//
//  ViewController.m
//  ClockApp
//
//  Created by adil on 17/04/2015.
//  Copyright (c) 2015 Adil Bougamza. All rights reserved.
//

#import "ViewController.h"

#define DEGREE_MIN                   6
#define DEGREE_HOUR                 30
#define DEGREE_ADVANCED_BY_MIN     0.5
#define TOTAL_DEGREES              360


@interface ViewController ()
{
    UIImageView* imageViewMinuteHandle;
    UIImageView* imageViewHourHandle;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerTime;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
@property (weak, nonatomic) IBOutlet UIView *viewClock;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.title =  @"Edit Alarm";

    // set the local of the date picker to show a 24 h
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"];
    [_datePickerTime setLocale:locale];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setAngleLabelMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(float) computeAngleBetweenHandlesForTime:(NSDate*)time
{
    float angle = 0;
    
    // Split the hour and minute in nsdate
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:time];

    // return only [0,12] hour format for ex H:14 (14>12) we return 14-12 = 2
    // because the wall hour only contains values in this range [0,12]
    // for the sake of this excercice H:00 = H:12 = 0
    NSInteger hours   = ( [components hour] >= 12 ) ? ([components hour] - 12) : [components hour];
    NSInteger minutes = [components minute];
    
    //  calculate the minutes handle degree
    //  60 minutes -> 360 degrees <==> 1 min -> 6 degrees
    float minutes_handle_degree = DEGREE_MIN * minutes;
    
    
    //  calculate the hours handle degree
    //  12 hours -> 360 degrees <==> 1 hour -> 30 degrees
    float hour_degree = DEGREE_HOUR * hours;
    
    // the hour's handle advance with minutes too. in one hour the handle advances 30 degrees
    // so 60 minutes -> 30 degrees <==> 1 min -> 1/2 = 0.5 degrees
    float hour_advanced_degree = DEGREE_ADVANCED_BY_MIN * minutes;
    
    // the exact hour's handle degree
    float hours_handle_degree = hour_degree + hour_advanced_degree;
    
    // set Clock handles
    [self setClockHandlesAtHour:hours_handle_degree andMinuteDegrees:minutes_handle_degree];
    
    // the angle between the two handles
    angle = fabs(hours_handle_degree - minutes_handle_degree);
    
    // if the angle > 180 we calculate the other side which eqults to 36- - angle
    angle = ( angle > TOTAL_DEGREES/2 ) ? (TOTAL_DEGREES - angle) : angle;
    
    return angle;
}

-(void) setClockHandlesAtHour:(float) hourDegrees andMinuteDegrees:(float) minuteDegrees
{
    // get the gradians from degrees
    float min_rad   = minuteDegrees * M_PI/180;
    float hour_rad  = hourDegrees * M_PI/180;
    
    // delete old images if exsiting and create new ones in the right angle
    if (imageViewMinuteHandle && imageViewHourHandle)
    {
        [imageViewMinuteHandle removeFromSuperview]; imageViewMinuteHandle = nil;
        [imageViewHourHandle removeFromSuperview]; imageViewHourHandle = nil;
    }
    
    [self addHandlesImages];
    
    // rotate the handle images to the right angles
    imageViewMinuteHandle.transform    = CGAffineTransformMakeRotation(min_rad);
    imageViewHourHandle.transform      = CGAffineTransformMakeRotation(hour_rad);
}

-(void) addHandlesImages
{
    imageViewMinuteHandle = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 128, 128)];
    imageViewMinuteHandle.image = [UIImage imageNamed:@"minutes.png"];
    [_viewClock addSubview:imageViewMinuteHandle];
    
    imageViewHourHandle = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 128, 128)];
    imageViewHourHandle.image = [UIImage imageNamed:@"hours.png"];
    [_viewClock addSubview:imageViewHourHandle];

}

-(void) setAngleLabelMessage
{
    float angle = [self computeAngleBetweenHandlesForTime:_datePickerTime.date];
    _labelMessage.text = [NSString stringWithFormat:@"The smaller angle between\nclock hands is %.2f degrees", angle];
}

#pragma mark IBActions

- (IBAction)datePickerValueChanged:(id)sender
{
    [self setAngleLabelMessage];
}



@end
