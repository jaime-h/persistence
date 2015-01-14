//
//  ViewController.m
//  Persistence
//
//  Created by Jaime Hernandez on 1/14/15.
//  Copyright (c) 2015 Jaime Hernandez. All rights reserved.
//
//  From the follwoing tutorial on persistence
//  http://www.binpress.com/tutorial/learn-objectivec-building-an-app-part-10-basic-data-persistence/103
//

#import "ViewController.h"

@interface ViewController ()
{
    id anInt;
    id aFloat;
    id obj1;
}
@property (nonatomic, strong) NSMutableDictionary *controlState;
@property (nonatomic, strong) NSMutableDictionary *sliderValues;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super init]))
        return nil;
    obj1   = [aDecoder decodeObjectForKey:@"obj1Key"];
    anInt  = [aDecoder decodeObjectForKey:@"IntValueKey"];
    aFloat = [aDecoder decodeObjectForKey:@"FloatValueKey"];
}


-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:obj1  forKey:@"obj1Key"];
    [encoder encodeInt:anInt    forKey:@"IntValueKey"];
    [encoder encodeFloat:aFloat forKey:@"FloatValueKey"];
}


- (IBAction)toggleSpinner:(id)sender
{
    if (self.spinner.isAnimating)
    {
        [self.spinner stopAnimating];
        ((UIButton *) sender).titleLabel.text = @"Start Spinning";
        [self.controlState setValue:[NSNumber numberWithBool:NO]forKey:@"SpinnerAnimatingState"];
    }
    else
    {
        [self.spinner startAnimating];
        ((UIButton *) sender).titleLabel.text = @"Stop Spinning";
        [self.controlState setValue:[NSNumber numberWithBool:YES]forKey:@"SpinnerAnimatingState"];

    }
}

- (IBAction)controlValueChanged:(id)sender
{
    if (sender == self.segments)
    {
        NSInteger selectedSegment = ((UISegmentedControl *)sender).selectedSegmentIndex;
        [[NSUserDefaults standardUserDefaults]setInteger:selectedSegment forKey:@"SelectedSegmentIndex"];
    }
    else if (sender == self.cSwitch)
    {
        [self.controlState setValue:[NSNumber numberWithBool:self.cSwitch.enabled] forKey:@"SwitchEnabledState"];
    }
    else if (sender == self.textField)
    {
        [self.controlState setValue:self.textField.text forKey:@"TextFieldContents"];
    }
    else if (sender == self.slider1)
    {
        [self.sliderValues setValue:[NSNumber numberWithFloat:self.slider1.value] forKey:@"Slider1Key"];
    }
    else if (sender == self.slider2)
    {
        [self.sliderValues setValue:[NSNumber numberWithFloat:self.slider2.value] forKey:@"Slider2Key"];
    }
    else if (sender == self.slider3)
    {
        [self.sliderValues setValue:[NSNumber numberWithFloat:self.slider3.value] forKey:@"Slider3Key"];
    }
    else
        NSLog(@"No hits?");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"componentState.plist"];
    [self.controlState writeToFile:filePath atomically:YES];
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.sliderValues forKey:@"SliderValues"];
    [archiver finishEncoding];
    NSString *dataPath = [documentsDirectoryPath stringByAppendingPathComponent:@"archivedObjects"];
    [data writeToFile:dataPath atomically:YES];
    
}
@end
