//
//  ViewController.m
//  Persistence
//
//  Created by Jaime Hernandez on 1/14/15.
//  Copyright (c) 2015 Jaime Hernandez. All rights reserved.
//
//  From the following tutorial on persistence
//  http://www.binpress.com/tutorial/learn-objectivec-building-an-app-part-10-basic-data-persistence/103
//

#import "ViewController.h"

@interface ViewController ()
//{
//    id anInt;
//    id aFloat;
//    id obj1;
//}



@end

@implementation ViewController

#pragma mark - ViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        self.controlState = [NSMutableDictionary dictionary];
        self.sliderValues = [NSMutableDictionary dictionary];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Load segmented control selection
    NSInteger selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedSegmentIndex"];
    self.segments.selectedSegmentIndex = selectedSegmentIndex;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    // Load data from plist
    if ([[self.controlState allKeys] count] == 0)
    {
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"componentState.plist"];
        self.controlState = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        
        if ([[self.controlState objectForKey:@"SpinnerAnimatingState"] boolValue])
            [self.spinner startAnimating];
        else
            [self.spinner stopAnimating];
        
        // self.nSwitch.enabled = [[self.controlState objectForKey:@"SwitchEnabledState"] boolValue];
        
        self.progressBar.progress = [[self.controlState objectForKey:@"ProgressBarProgress"] floatValue];
        
        self.textField.text = [self.controlState objectForKey:@"TextFieldContents"];
    }
    
    // Decode objects
    if ([[self.sliderValues allKeys] count] == 0)
    {
        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[documentsDirectoryPath stringByAppendingPathComponent:@"archivedObjects"]];
        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.sliderValues = [decoder decodeObjectForKey:@"SliderValues"];
        self.slider1.value = [[self.sliderValues objectForKey:@"Slider1Key"] floatValue];
        self.slider2.value = [[self.sliderValues objectForKey:@"Slider2Key"] floatValue];
        self.slider3.value = [[self.sliderValues objectForKey:@"Slider3Key"] floatValue];
    }
    
    // Read text file
    NSString *textViewData = [NSString stringWithContentsOfFile:[documentsDirectoryPath stringByAppendingPathComponent:@"TextViewContents.txt"] encoding:NSUTF8StringEncoding error:nil];
    self.textBox.text = textViewData;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - IBAction Methods

- (IBAction)toggleSpinner:(id)sender
{
    if (self.spinner.isAnimating)
    {
        [self.spinner stopAnimating];
        ((UIButton *)sender).titleLabel.text = @"Start Spinning";
        [self.controlState setValue:[NSNumber numberWithBool:NO]forKey:@"SpinnerAnimatingState"];
    }
    else
    {
        [self.spinner startAnimating];
        ((UIButton *)sender).titleLabel.text = @"Stop Spinning";
        [self.controlState setValue:[NSNumber numberWithBool:YES]forKey:@"SpinnerAnimatingState"];

    }
}

- (IBAction)controlsValueDidChange:(id)sender
{
    if (!self.controlState)
        self.controlState = [NSMutableDictionary dictionary];
    if (!self.sliderValues)
        self.sliderValues = [NSMutableDictionary dictionary];
    
    if (sender == self.segments)
    {
        NSInteger selectedSegment = ((UISegmentedControl *)sender).selectedSegmentIndex;
        [[NSUserDefaults standardUserDefaults]setInteger:selectedSegment forKey:@"SelectedSegmentIndex"];
    }
    else if (sender == self.nSwitch)
    {
        [self.controlState setValue:[NSNumber numberWithBool:self.nSwitch.enabled] forKey:@"SwitchEnabledState"];
    }
    else if (sender == self.textField)
    {
        [self.controlState setValue:self.textField.text forKey:@"TextFieldContents"];
    }
    else if (sender == self.slider1)
    {
        [self.sliderValues setValue:[NSNumber numberWithFloat:self.slider1.value] forKey:@"Slider1Key"];
        
        // Update progress bar with slider
        [self.progressBar setProgress:self.slider1.value];
        [self.controlState setValue:[NSNumber numberWithFloat:self.progressBar.progress] forKey:@"ProgressBarProgress"];
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

- (IBAction)switch:(UISwitch *)sender {
}

- (IBAction)didTouchSwitch:(id)sender
{
    if (sender == self.nSwitch)
    {
        [self.controlState setValue:[NSNumber numberWithBool:self.nSwitch.enabled] forKey:@"SwitchEnabledState"];
    }

}

#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *textViewContents = textView.text;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"TextViewContents.txt"];
    [textViewContents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
