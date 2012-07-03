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

#pragma mark - custom setters and getters

//This method is called whenever the showEqualSign property is updated.
//the equal sign is automatically added or removed appropriately just by updating the value of the ShowEqualSign property
-(void)setShowEqualSign:(BOOL)showEqualSign{
    
    //set the instance variable showEqualSign
    _showEqualSign = showEqualSign;

    //first get the existing location of the equal sign in the display
    NSUInteger equalSignLocation = [self.calculatorProgramDisplay.text rangeOfString:@"="].location;

    //if the equal sign is being set, add it only if it is not already there
    if (showEqualSign) {
        if (equalSignLocation == NSNotFound) {
            self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:@"="];
        }
    //if the equal sign is being removed, check to see if one is present and then remove it
    }else{
        if (equalSignLocation != NSNotFound){
            self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text substringToIndex:equalSignLocation];
        }
    }
}

#pragma mark - React To Buttons
//------- React to Buttons ------------------//
- (IBAction)digitPressed:(UIButton *)sender{

    //Get digit from button title
    NSString *digit = [sender currentTitle];
    NSLog(@"digit pressed = %@", digit);
    
    //if the user was not entering a number, they are now, then return
    if (!self.userIsInTheMiddleOfEnteringANumber)
    {
        //remove equal sign from calculator program log if there is one
        self.showEqualSign = NO;
            
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.display.text = digit;
        
        return;
    }
        
    //if a decimal is pressed, make sure there isn't one already, then return.
    if ([digit isEqualToString:@"."])
    {
        if( [self.display.text rangeOfString:@"."].location != NSNotFound){return;}
    }

    //if the user was already entering a number append it unless the existing display is zero.  In that case replace it
    if ([self.display.text isEqualToString:@"0"]) {
        self.display.text = digit;
    }else{
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    NSString *operation = [sender currentTitle];
    
    //press enter if the user didn't yet
    if (self.userIsInTheMiddleOfEnteringANumber){[self enterPressed];}
    else{
            self.calculatorProgramDisplay.text =[self.calculatorProgramDisplay.text stringByAppendingString:@" "];
        }
    
    
    /// --- update the calculator program log ---///
    //hide equal sign so that the operation can be put there
    self.showEqualSign = NO;
    
    //log the operation and space to the calculator program log
    self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:operation];
    self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:@" "];
    
    //add the equal sign back
    self.showEqualSign = YES;
    //////////////
    
    //run the calculation
    double result = [self.brain performOperation:operation];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
  
    //put the result back on the stack and on the display
    [self.brain pushOperand:result];
    self.display.text = resultString;
}
- (IBAction)enterPressed {
    //add number to the calculator program log followed by a space
    self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:self.display.text];
    self.calculatorProgramDisplay.text = [self.calculatorProgramDisplay.text stringByAppendingString:@" "];

    //push the number onto the operand stack
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    //reset decimalPressed and userIsInTheMiddleofEnteringANumber properties to No
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;
}

- (IBAction)clearPressed {
    //reset everything
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;
    self.display.text = @"0";
    self.calculatorProgramDisplay.text = @"";
    [self.brain clearOperands];
}

- (IBAction)backSpacePressed:(id)sender {
    //only use the backspace if the user is in the middle of entering a number
    if (self.userIsInTheMiddleOfEnteringANumber){
        
        //if more than one digit has been pressed, change new entry from zero to display less one digit
        if (self.display.text.length > 1){
            self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        }else{
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
}

- (IBAction)negativePressed:(id)sender {
    //if the user is entering a number, just either add or remove the negative sign from the display
    if (self.userIsInTheMiddleOfEnteringANumber){
        if ([self.display.text rangeOfString:@"-"].location == NSNotFound) {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }else{
            self.display.text = [self.display.text substringFromIndex:1];
        }

    //if the user is not in the middle of entering a number, pass +/- through as an operation
    }else{
        [self operationPressed:sender];
    }
}

#pragma mark - memory cleanup

//---------------------------------------------

- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setCalculatorProgramDisplay:nil];
    [super viewDidUnload];
}
@end
