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
            self.keylog.text = [self.keylog.text stringByAppendingString:digit];
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
    self.keylog.text = [self.keylog.text stringByAppendingString:digit];             
}

- (IBAction)operationPressed:(UIButton *)sender {     
    NSString *operation = [sender currentTitle];
    
    if (self.userIsInTheMiddleOfEnteringANumber){[self enterPressed];}
    else{
        self.keylog.text =[self.keylog.text stringByAppendingString:@" "];
        }
    
    //log the operation and space to the key log
    self.keylog.text = [self.keylog.text stringByAppendingString:operation];
    self.keylog.text = [self.keylog.text stringByAppendingString:@" "];
    
    double result = [self.brain performOperation:operation];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
  
    [self.brain pushOperand:result];
    self.display.text = resultString;
}
- (IBAction)enterPressed {
    //add a space to the log
    self.keylog.text = [self.keylog.text stringByAppendingString:@" "];

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
- (IBAction)backSpacePressed:(id)sender {
    //only use the backspace if the user is in the middle of entering a number
    if (self.userIsInTheMiddleOfEnteringANumber){
        //current entry is the display's text
        NSString * currentEntry = self.display.text;
    
        //initialize the new entry to zero
        NSString * newEntry = @"0";
    
        //if more than one digit has been pressed, change new entry from zero to display less one digit
        if (currentEntry.length > 1){
            newEntry = [currentEntry substringToIndex:[currentEntry length]-1];
        }
    
        //set display to the new entry
        self.display.text = newEntry;
    
        //if current entry was not zero, replace it with the new entry in the program log
        if (![currentEntry isEqualToString:@"0"]){
            int entryIndexinKeylog = self.keylog.text.length - currentEntry.length;

            //remove old value
            self.keylog.text = [self.keylog.text substringToIndex:entryIndexinKeylog];
        
            //replace it with new value
            self.keylog.text = [self.keylog.text stringByAppendingString:newEntry];
        }
        else{
            //user is no longer entering a number
            self.userIsInTheMiddleOfEnteringANumber = NO;
            //remove last digit from the program log
            self.keylog.text = [self.keylog.text substringToIndex:[self.keylog.text length]-1];
        }
    }
}

//---------------------------------------------

- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setKeylog:nil];
    [super viewDidUnload];
}
@end
