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
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

//----- synthesize displays ---------//
@synthesize display = _display; 
@synthesize keylog = _keylog;

//------- synthesize properties -----//
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize decimalPressed = _decimalPressed;

//------- synthesize and init model ----------//
@synthesize brain = _brain;
- (CalculatorBrain *)brain{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
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
        if( [self.display.text rangeOfString:@"."].location != NSNotFound){return;}
    }

    //put the digit on the display and log
    self.display.text = [self.display.text stringByAppendingString:digit];
}

- (IBAction)operationPressed:(UIButton *)sender {     
    NSString *operation = [sender currentTitle];
    
    if (self.userIsInTheMiddleOfEnteringANumber){[self enterPressed];}

    double result = [self.brain performOperation:operation];

    self.keylog.text = [CalculatorBrain descriptionOfProgram:_brain.program];

    NSString *resultString = [NSString stringWithFormat:@"%g", result];
  
    [self.brain pushOperand:result];
    self.display.text = resultString;
}
- (IBAction)enterPressed {
    self.keylog.text = [CalculatorBrain descriptionOfProgram:_brain.program];

    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;   
}
- (IBAction)clearPressed {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;
    self.display.text = @"0";
    self.keylog.text = @"";
    [self.brain clearOperands];
}
//---------------------------------------------

- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setKeylog:nil];
    [super viewDidUnload];
}
@end
