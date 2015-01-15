//
//  ViewController.h
//  Persistence
//
//  Created by Jaime Hernandez on 1/14/15.
//  Copyright (c) 2015 Jaime Hernandez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segments;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UISwitch *cSwitch;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *spinningButton;
@property (strong, nonatomic) IBOutlet UISlider *slider1;
@property (strong, nonatomic) IBOutlet UISlider *slider2;
@property (strong, nonatomic) IBOutlet UISlider *slider3;
@property (strong, nonatomic) IBOutlet UITextView *textBox;

@property (nonatomic, strong) NSMutableDictionary *controlState;
@property (nonatomic, strong) NSMutableDictionary *sliderValues;


- (IBAction)toggleSpinner:(id)sender;
- (IBAction)controlsValueDidChange:(id)sender;

@end

