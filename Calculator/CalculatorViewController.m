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


@interface CalculatorViewController() <GraphViewControllerDelegate>
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL decimalPressed;
@property (nonatomic, strong) NSArray * thisProgram;
@property (nonatomic, strong) NSArray * testVariableValues;
@property (nonatomic, strong) NSMutableDictionary * validVariables;
@property (nonatomic) BOOL showEqualSign;
@end

@implementation CalculatorViewController

//----- synthesize displays ---------//
@synthesize display = _display;

//------- synthesize properties -----//
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize decimalPressed = _decimalPressed;
@synthesize showEqualSign = _showEqualSign;
@synthesize testVariableValues = _testVariableValues;
@synthesize validVariables = _validVariables;
@synthesize thisProgram = _thisProgram;


-(NSDictionary *) validVariables{
    //Set X as a valid variable unless it has already been set
    if (!_validVariables){
        _validVariables = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:0] forKey:@"x"];
    }
    
    return _validVariables;
}


-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation{
    if (!self.splitViewController){
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark - Split View Delegate Stuff

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

#pragma mark - custom setters and getters
//This method is called whenever the showEqualSign property is updated.
//the equal sign is automatically added or removed appropriately just by updating the value of the ShowEqualSign property
-(void)setShowEqualSign:(BOOL)showEqualSign{
    
    //set the instance variable showEqualSign
    _showEqualSign = showEqualSign;
    
    //first get the existing location of the equal sign in the display
    NSUInteger equalSignLocation = [self.title rangeOfString:@"="].location;
    
    //if the equal sign is being set, add it only if it is not already there
    if (showEqualSign) {
        if (equalSignLocation == NSNotFound) {
            self.title = [self.title stringByAppendingString:@"="];
        }
        //if the equal sign is being removed, check to see if one is present and then remove it
    }else{
        if (equalSignLocation != NSNotFound){
            self.title = [self.title substringToIndex:equalSignLocation];
        }
    }
}
 
-(NSArray*) thisProgram{
    if (_thisProgram == nil) _thisProgram = [[NSArray alloc] init];
    return _thisProgram;
}

-(void) refreshDisplays{
    //refresh main display
    id result = [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.validVariables];
    self.display.text = [NSString stringWithFormat:@"%@", result];

    //refresh log
    if ([self.thisProgram count] == 0) {
        self.title = @"Drew's Calculator";
    }else{
        self.title = [CalculatorBrain descriptionOfProgram:self.thisProgram];
    }

    //if ipad refresh graph
    if ([self splitViewGraphViewController]){
        [[self splitViewGraphViewController] setGraphProgram:self.thisProgram];
        [[self splitViewGraphViewController] setDelegate:self];
        
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
        
        //backspace
        [self backSpacePressed:self];
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
    [CalculatorBrain runProgram:self.thisProgram usingVariableValues:self.validVariables];
    
    [self refreshDisplays];
}

- (IBAction)enterPressed {
    NSNumber * thisNumber = [NSNumber numberWithDouble:[self.display.text doubleValue]];
    
    //add the number to thisProgram
    self.thisProgram = [self.thisProgram arrayByAddingObject:thisNumber];
    
    [self refreshDisplays];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;
}

- (IBAction)clearPressed {
    //reset everything
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalPressed = NO;
    self.display.text = @"0";
    self.title = @"Drew's Calculator";
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

#pragma mark - Graphing stuff

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

#pragma GraphViewDelegate
-(void) graphViewController:(GraphViewController *)sender chooseProgram:(id)program{
    self.thisProgram = program;
    [self refreshDisplays];
}

#pragma mark - memory cleanup
//This stuff is probably not needed anymore, but the compiler put it there and there and it doesn't hurt to leave it
//---------------------------------------------

- (void)viewDidUnload {
    [self setDisplay:nil];
    [super viewDidUnload];
}
@end
