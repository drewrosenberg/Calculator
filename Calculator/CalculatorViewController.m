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

/* just playing around with rotation
 -(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation{
    return YES;
}
*/ 
 
-(NSArray *)testVariableValues{
    if (_testVariableValues == nil)
    {
        _testVariableValues = [[NSArray alloc] init];
        
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
                                [NSNumber numberWithDouble:1],@"x",
                                [NSNumber numberWithDouble:1],@"y",
                                [NSNumber numberWithDouble:1],@"foo", 
                                nil]];
        
        //test variable set 3
        _testVariableValues = [_testVariableValues arrayByAddingObject:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithDouble:2],@"x",
                                [NSNumber numberWithDouble:2],@"y",
                                [NSNumber numberWithDouble:2],@"foo", 
                                nil]];
   
    }

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

-(void) refreshDisplays{
    //refresh main display
    double result = [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.activeVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];

    //refresh log
    self.keylog.text = [CalculatorBrain descriptionOfProgram:self.thisProgram];

    //refresh variable display
    self.variableDisplay.text = @"";
    for (NSString * thisVariable in [CalculatorBrain variablesUsedInProgram:self.thisProgram]) {
        self.variableDisplay.text = [NSString stringWithFormat:@"%@ %@=%@", self.variableDisplay.text, thisVariable, [self.activeVariableValues objectForKey:thisVariable]];
    }
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

    [self refreshDisplays];
}

- (IBAction)undoPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber){
        //remove last character and refresh display
        if ([self.display.text length] != 0){
            self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        }
    }
    else {
        //remove last object and refresh displays
        NSMutableArray *mutableProgram;
        mutableProgram = [self.thisProgram mutableCopy];
        [mutableProgram removeObject:[mutableProgram lastObject]];
        self.thisProgram = mutableProgram;
        [self refreshDisplays];                
    }
}


- (IBAction)variablePressed:(id)sender {
    NSString *variable = [sender currentTitle];
    self.display.text = variable;
    
    //add the variable and run the program
    self.thisProgram = [self.thisProgram arrayByAddingObject:variable];
    [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.activeVariableValues];
    
    [self refreshDisplays];
}

- (IBAction)testButtonPressed:(id)sender {
    NSString * testButton = [sender currentTitle];
    int index = [[testButton substringFromIndex:[testButton length]-1] intValue];
    
    self.activeVariableValues = [self.testVariableValues objectAtIndex:index];
    
    [self refreshDisplays];

    //recaculate with new variables
    double result = [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.activeVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
} 

- (IBAction)enterPressed {
    NSNumber * thisNumber = [NSNumber numberWithDouble:[self.display.text doubleValue]];

    self.thisProgram = [self.thisProgram arrayByAddingObject:thisNumber];
    
    //[CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.activeVariableValues];
    
    [self refreshDisplays];
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
