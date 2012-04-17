//
//  GraphViewController.m
//  Calculator
//
//  Created by Drew Rosenberg on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#include "CalculatorBrain.h"

@interface GraphViewController ()
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) NSArray * graphPoints;
@end

@implementation GraphViewController
@synthesize graphProgram = _graphProgram;
@synthesize graphView = _graphView;
@synthesize graphPoints = _graphPoints;

-(NSArray*) graphProgram{
    if (_graphProgram == nil){
        _graphProgram = [[NSArray alloc] init];
    }
    return _graphProgram;
}

-(void) setGraphProgram:(NSArray *)graphProgram{
    _graphProgram = graphProgram;
    //load graphPoints with the results of 
    //[calculatorbrain runProgram:graphProgram usingVariables:x=?].  Loop for x
    [self.graphView setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == YES);
}

@end
