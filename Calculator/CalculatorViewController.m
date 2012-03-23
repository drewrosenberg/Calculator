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


//-------- check to see if a character has been entered--//
-(BOOL)pressed:(NSString *)character {
    NSRange textRange;
    textRange = [self.display.text rangeOfString:character];
    
    if (textRange.location != NSNotFound){
        return YES;
    }
    else{return NO;}
    
    //------------------------------------
}

//------- React to Buttons ------------------//
- (IBAction)digitPressed:(UIButton *)sender{

    //---- Get digit from button title
    NSString *digit = [sender currentTitle];
    NSLog(@"digit pressed = %@", digit);
    
    if ([self.display.text isEqualToString:@"0"])
    {
        //no digit has been entered yet so don't append zeros
        if ([@"0" isEqualToString:digit]){return;}
    }
    
    if ([@"." isEqualToString:digit]){
        if (![self pressed:@"."]){
            self.display.text = [self.display.text stringByAppendingString:digit];
            self.keylog.text = [self.keylog.text stringByAppendingString:digit];
        }
    }
    else if ([self.display.text isEqualToString:@"0"]){
        if (![@"0" isEqualToString:digit]){
            self.display.text = digit;
            self.keylog.text = [self.keylog.text stringByAppendingString:digit];             
        }
    }
    else {
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.keylog.text = [self.keylog.text stringByAppendingString:digit];             
    }
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
//---------------------------------------------

- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setKeylog:nil];
    [super viewDidUnload];
}
@end
