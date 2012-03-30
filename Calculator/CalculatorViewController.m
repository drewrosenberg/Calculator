//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Andrew Rosenberg on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"


@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL decimalPressed;
@property (nonatomic, strong) NSArray * thisProgram;
@property (nonatomic, strong) NSDictionary * testVariableValues;
@end

@implementation CalculatorViewController

//----- synthesize displays ---------//
@synthesize display = _display; 
@synthesize keylog = _keylog;

//------- synthesize properties -----//
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize decimalPressed = _decimalPressed;
@synthesize testVariableValues = _testVariableValues;
@synthesize thisProgram = _thisProgram;
//------- synthesize and init model ----------//

-(NSDictionary *)testVariableValues{
    _testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:2],@"x",
                           [NSNumber numberWithDouble:3],@"y",
                           [NSNumber numberWithDouble:1.5],@"foo", 
                           nil];
    return _testVariableValues;
}

-(NSArray*) thisProgram{
    if (_thisProgram == nil) _thisProgram = [[NSArray alloc] init];
    return _thisProgram;
}

//------- React to Buttons ------------------//
- (IBAction)digitPressed:(UIButton *)sender{

    //Get digit from button title
    NSString *digit = [sender currentTitle];
    NSLog(@"digit pressed = %@", digit);
    
    
    if (!self.userIsInTheMiddleOfEnteringANumber)
    {
        if (digit !=@"0"){
            self.userIsInTheMiddleOfEnteringANumber = YES;
            self.display.text = digit;
        }
        return;
    }
        
    //if a decimal is pressed, make sure there isn't one already
    if ([digit isEqualToString:@"."])
    {
        //return if decimal is already present
        if( [self.display.text rangeOfString:@"."].location != NSNotFound){return;}
    }

    //put the digit or decimal on the display
    self.display.text = [self.display.text stringByAppendingString:digit];
}

- (IBAction)operationPressed:(UIButton *)sender {     
    NSString *operation = [sender currentTitle];
    
    if (self.userIsInTheMiddleOfEnteringANumber){[self enterPressed];}

    self.thisProgram = [self.thisProgram arrayByAddingObject:operation];
    double result = [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.testVariableValues];
   
    self.keylog.text = [CalculatorBrain descriptionOfProgram:self.thisProgram];

    NSString *resultString = [NSString stringWithFormat:@"%g", result];
  
    self.display.text = resultString;
}
- (IBAction)variablePressed:(id)sender {
    NSString *variable = [sender currentTitle];
    self.display.text = variable;
    self.thisProgram = [self.thisProgram arrayByAddingObject:variable];
    [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.testVariableValues];
}

- (IBAction)enterPressed {
    NSNumber * thisNumber = [NSNumber numberWithDouble:[self.display.text doubleValue]];

    self.thisProgram = [self.thisProgram arrayByAddingObject:thisNumber];
    
    [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.testVariableValues];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;   
}

- (IBAction)clearPressed {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;
    self.display.text = @"0";
    self.keylog.text = @"";
    self.thisProgram = nil;
}
//---------------------------------------------

- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setKeylog:nil];
    [super viewDidUnload];
}
@end
