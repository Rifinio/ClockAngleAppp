//
//  ViewController.m
//  ClockApp
//
//  Created by adil on 17/04/2015.
//  Copyright (c) 2015 Adil Bougamza. All rights reserved.
//

#import "ViewController.h"

#define DEGREE_MIN                  6
#define DEGREE_HOUR                 30
#define DEGREE_ADVANCED_BY_MIN     0.5
#define TOTAL_DEGREES              360


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerTime;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // set the local of the date picker to show a 24 h
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"];
    [_datePickerTime setLocale:locale];
    

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
    
    NSInteger hour   = ( [components hour] >= 12 ) ? ([components hour] - 12) : [components hour];
    NSInteger minute = [components minute];

    NSLog(@"hour : %ld  min : %ld",hour,minute);
    
    //  calculate the minutes handle degree
    //  60 minutes -> 360 degrees <==> 1 min -> 6 degrees
    float minutes_handle_degree = DEGREE_MIN * minute;
    
    
    //  calculate the hours handle degree
    //  12 hours -> 360 degrees <==> 1 hour -> 30 degrees
    float hour_degree = DEGREE_HOUR * hour;
    
    // the hour's handle advance with minutes too. in one hour the handle advances 30 degrees
    // so 60 minutes -> 30 degrees <==> 1 min -> 1/2 = 0.5 degrees
    float hour_advanced_degree = DEGREE_ADVANCED_BY_MIN * minute;
    
    float hours_handle_degree = hour_degree + hour_advanced_degree;
    
    angle = fabs(hours_handle_degree - minutes_handle_degree);
    
    angle = ( angle > TOTAL_DEGREES/2 ) ? (TOTAL_DEGREES - angle) : angle;
    
    NSLog(@"angle %f",angle);

    return angle;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)datePickerValueChanged:(id)sender {
    
    float angle = [self computeAngleBetweenHandlesForTime:_datePickerTime.date];
    
    _labelMessage.text = [NSString stringWithFormat:@"%.2f degrees", angle];
}

@end
