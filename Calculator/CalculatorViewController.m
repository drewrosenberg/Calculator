//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Andrew Rosenberg on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"
#import "splitViewBarButtonItemPresenter.h"


@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL decimalPressed;
@property (nonatomic, strong) NSArray * thisProgram;
@property (nonatomic, strong) NSArray * testVariableValues;
@property (nonatomic, strong) NSMutableDictionary * activeVariableValues;
@end

@implementation CalculatorViewController

//----- synthesize displays ---------//
@synthesize display = _display;

//------- synthesize properties -----//
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize decimalPressed = _decimalPressed;
@synthesize testVariableValues = _testVariableValues;
@synthesize activeVariableValues = _activeVariableValues;
@synthesize thisProgram = _thisProgram;

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation{
    if (!self.splitViewController){
        return NO;
    }
    else{
        return YES;
    }
}

//------------split view delegate stuff
-(void) awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

-(id <splitViewBarButtonItemPresenter> )splitViewBarButtonItemPresenter{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if ([detailVC conformsToProtocol:@protocol(splitViewBarButtonItemPresenter)]){
        return detailVC;
    }else return nil;
}

-(BOOL) splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation
{
    NSLog(@"%s", __FUNCTION__);
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

-(void) splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    NSLog(@"%s", __FUNCTION__);
    barButtonItem.title = self.title;
    [pc setPopoverContentSize:CGSizeMake(480.0f, 320.0f) animated:NO];
    //tell the detail view to put this button up
    if (!self.title) self.title = @"Drew's Calculator";
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

-(void) splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSLog(@"%s", __FUNCTION__);
    //tell the detail view to take the button away
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}
 
//------- synthesize and init test variables and model ----------//
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
//- (IBAction)xValueChanged:(id)sender {
  //  [self.activeVariableValues setValue:[sender //currentTitle] forKey:@"x"];
//}

-(NSArray*) thisProgram{
    if (_thisProgram == nil) _thisProgram = [[NSArray alloc] init];
    return _thisProgram;
}

-(void) refreshDisplays{
    //refresh main display
    double result = [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.activeVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];

    //refresh log
    if ([self.thisProgram count] == 0) {
        self.title = @"Drew's Calculator";
    }else{
        self.title = [CalculatorBrain descriptionOfProgram:self.thisProgram];
    }

    //if ipad refresh graph
    if ([self splitViewGraphViewController]){
        [[self splitViewGraphViewController] setGraphProgram:self.thisProgram];
        
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
    if (self.userIsInTheMiddleOfEnteringANumber){[self enterPressed];}

    self.display.text = variable;
    
    //add the variable and run the program
    self.thisProgram = [self.thisProgram arrayByAddingObject:variable];
    [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.activeVariableValues];
    
    [self refreshDisplays];
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
    self.thisProgram = nil;
    [self refreshDisplays];
}

-(GraphViewController *)splitViewGraphViewController
{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[GraphViewController class]]){
        gvc = nil;
    }
    return gvc;
}

//----- Graph button ------
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Graph"]){
        //graph segue preparation
        [segue.destinationViewController setGraphProgram:self.thisProgram];           
    }
        
}

//---------------------------------------------

- (void)viewDidUnload {
    [self setDisplay:nil];
    [super viewDidUnload];
}
@end
