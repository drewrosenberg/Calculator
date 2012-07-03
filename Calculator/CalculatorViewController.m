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
@property (nonatomic) BOOL showEqualSign;
@end

@implementation CalculatorViewController

//----- synthesize displays ---------//
@synthesize display = _display; 
@synthesize calculatorProgramDisplay = _calculatorProgramDisplay;

//------- synthesize properties -----//
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize decimalPressed = _decimalPressed;
@synthesize showEqualSign = _showEqualSign;

//------- synthesize and init model ----------//
@synthesize brain = _brain;
- (CalculatorBrain *)brain{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

-(void)setShowEqualSign:(BOOL)showEqualSign{
    _showEqualSign = showEqualSign;

    NSUInteger equalSignLocation = [self.calculatorProgramDisplay.text rangeOfString:@"="].location;
    if (showEqualSign) {
        if (equalSignLocation == NSNotFound) {
            self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:@"="];
        }
    }else{
        if (equalSignLocation != NSNotFound){
            self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text substringToIndex:equalSignLocation];
        }
    }
}

//------- React to Buttons ------------------//
- (IBAction)digitPressed:(UIButton *)sender{

    //remove equal sign from calculator program log if there is one
    self.showEqualSign = NO;

    //Get digit from button title
    NSString *digit = [sender currentTitle];
    NSLog(@"digit pressed = %@", digit);
    
    
    if (!self.userIsInTheMiddleOfEnteringANumber)
    {
        if (digit !=@"0"){
            self.userIsInTheMiddleOfEnteringANumber = YES;
            self.display.text = digit;
            self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:digit];
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
    self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:digit];
}

- (IBAction)operationPressed:(UIButton *)sender {
    NSString *operation = [sender currentTitle];
    
   
    if (self.userIsInTheMiddleOfEnteringANumber){[self enterPressed];}
    else{
            self.calculatorProgramDisplay.text =[self.calculatorProgramDisplay.text stringByAppendingString:@" "];
        }
    
    //log the operation and space to the key log
    self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:operation];
    self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:@" "];
    //show the equal sign if there is none
    self.showEqualSign = YES;

    
    double result = [self.brain performOperation:operation];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
  
    [self.brain pushOperand:result];
    self.display.text = resultString;
}
- (IBAction)enterPressed {
    //add a space to the log
    self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:@" "];

    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;
}
- (IBAction)clearPressed {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;
    self.display.text = @"0";
    self.calculatorProgramDisplay.text = @"";
    [self.brain clearOperands];
}

- (IBAction)backSpacePressed:(id)sender {
    //only use the backspace if the user is in the middle of entering a number
    if (self.userIsInTheMiddleOfEnteringANumber){
        
        //set variable to current entry and initialize newEntry to zero
        NSString * currentEntry = self.display.text;
        NSString * newEntry = @"0";
    
        //if more than one digit has been pressed, change new entry from zero to display less one digit
        if (currentEntry.length > 1){
            newEntry = [currentEntry substringToIndex:[currentEntry length]-1];
        }
    
        //set display to the new entry
        self.display.text = newEntry;
    
        //if current entry was not zero, replace it with the new entry in the program log
        if (![currentEntry isEqualToString:@"0"]){
            int entryIndexincalculatorProgramDisplay = self.calculatorProgramDisplay.text.length - currentEntry.length;

            //remove old value
            self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text substringToIndex:entryIndexincalculatorProgramDisplay];
        
            //replace it with new value
            self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:newEntry];
        }
        else{
            //user is no longer entering a number
            self.userIsInTheMiddleOfEnteringANumber = NO;
            //remove last digit from the program log
            self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text substringToIndex:[self.calculatorProgramDisplay.text length]-1];
        }
    }
}

//---------------------------------------------

- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setCalculatorProgramDisplay:nil];
    [super viewDidUnload];
}
@end
