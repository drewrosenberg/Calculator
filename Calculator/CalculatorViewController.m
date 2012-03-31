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
@property (nonatomic, strong) NSArray * testVariableValues;
@property (nonatomic, strong) NSDictionary * activeVariableValues;
@end

@implementation CalculatorViewController

//----- synthesize displays ---------//
@synthesize display = _display; 
@synthesize keylog = _keylog;
@synthesize variableDisplay = _variableDisplay;

//------- synthesize properties -----//
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize decimalPressed = _decimalPressed;
@synthesize testVariableValues = _testVariableValues;
@synthesize activeVariableValues = _activeVariableValues;
@synthesize thisProgram = _thisProgram;
//------- synthesize and init test variables and model ----------//

-(NSArray *)testVariableValues{
    //test variable set 1 (active set)
    _testVariableValues = [_testVariableValues arrayByAddingObject:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:0],@"x",
                           [NSNumber numberWithDouble:0],@"y",
                           [NSNumber numberWithDouble:0],@"foo", 
                           nil]];
    
    //test variable set 2
    _testVariableValues = [_testVariableValues arrayByAddingObject:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithDouble:0],@"x",
                            [NSNumber numberWithDouble:0],@"y",
                            [NSNumber numberWithDouble:0],@"foo", 
                            nil]];

    //test variable set 3
    _testVariableValues = [_testVariableValues arrayByAddingObject:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithDouble:0],@"x",
                            [NSNumber numberWithDouble:0],@"y",
                            [NSNumber numberWithDouble:0],@"foo", 
                            nil]];


        return _testVariableValues;
}

-(NSDictionary *) activeVariableValues{
    //initialize to test1 button values
    if (!_activeVariableValues){
    _activeVariableValues = [self.testVariableValues objectAtIndex:0];
    }
    
    return _activeVariableValues;
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
    double result = [CalculatorBrain runProgram:self.thisProgram usingVariableValues:[self.testVariableValues objectAtIndex:0]];
   
    self.keylog.text = [CalculatorBrain descriptionOfProgram:self.thisProgram];

    NSString *resultString = [NSString stringWithFormat:@"%g", result];
  
    self.display.text = resultString;
}



- (IBAction)variablePressed:(id)sender {
    NSString *variable = [sender currentTitle];
    self.display.text = variable;

    //if the variable is not in the program, then add it to the display
    if ( ![[CalculatorBrain variablesUsedInProgram:self.thisProgram] containsObject:variable])
    {
        self.variableDisplay.text = [NSString stringWithFormat:@"%@ %@=%@", self.variableDisplay.text, variable, [self.activeVariableValues objectForKey:variable]];
    }    
    
    //add the variable and run the program
    self.thisProgram = [self.thisProgram arrayByAddingObject:variable];
    [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.activeVariableValues];
}

- (IBAction)testButtonPressed:(id)sender {
    NSString * testButton = [sender currentTitle];
    int index = [[testButton substringFromIndex:[testButton length]] intValue];
    
    self.activeVariableValues = [self.testVariableValues objectAtIndex:index];
}

- (IBAction)enterPressed {
    NSNumber * thisNumber = [NSNumber numberWithDouble:[self.display.text doubleValue]];

    self.thisProgram = [self.thisProgram arrayByAddingObject:thisNumber];
    
    [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.activeVariableValues];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;   
}

- (IBAction)clearPressed {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;
    self.display.text = @"0";
    self.keylog.text = @"";
    self.variableDisplay.text = @"";
    self.thisProgram = nil;
}
//---------------------------------------------

- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setKeylog:nil];
    [self setVariableDisplay:nil];
    [super viewDidUnload];
}
@end
