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
@property (nonatomic) BOOL showEqualSign;
@end

@implementation CalculatorViewController

//----- synthesize displays ---------//
@synthesize display = _display; 
@synthesize calculatorProgramDisplay = _calculatorProgramDisplay;
@synthesize variableDisplay = _variableDisplay;

//------- synthesize properties -----//
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize decimalPressed = _decimalPressed;
@synthesize showEqualSign = _showEqualSign;
@synthesize testVariableValues = _testVariableValues;
@synthesize activeVariableValues = _activeVariableValues;
@synthesize thisProgram = _thisProgram;

//------- synthesize and init variables and model ----------//

-(void) refreshDisplays{
    //refresh main display
    double result = [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.activeVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    //refresh log
    self.calculatorProgramDisplay.text = [CalculatorBrain descriptionOfProgram:self.thisProgram];
    
    //refresh variable display
    self.variableDisplay.text = @"";
    for (NSString * thisVariable in [CalculatorBrain variablesUsedInProgram:self.thisProgram]) {
        self.variableDisplay.text = [NSString stringWithFormat:@"%@ %@=%@", self.variableDisplay.text, thisVariable, [self.activeVariableValues objectForKey:thisVariable]];
    }
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
    
    //hide equal sign so that the operation can be put there
    self.showEqualSign = NO;
    
    //add the operation to the program
    self.thisProgram = [self.thisProgram arrayByAddingObject:operation];
    
    //refresh all of the displays
    [self refreshDisplays];
    
    //add the equal sign back
    self.showEqualSign = YES;
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
    //reset everything
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;
    self.display.text = @"0";
    self.variableDisplay.text = @"";
    self.thisProgram = nil;
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
    [self setVariableDisplay:nil];
    [super viewDidUnload];
}
@end
