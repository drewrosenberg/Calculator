//
//  GraphViewController.m
//  Calculator
//
//  Created by Drew Rosenberg on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController
@synthesize graphView = _graphView;

-(void) setGraphView:(GraphView*)graphView{
    //load graphPoints with the results of 
    //[calculatorbrain runProgram:graphProgram usingVariables:x=?].  Loop for x

 /*   for (double xValue=-10; xValue==10; xValue+=.01) {
        NSDictionary * variables = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:xValue] forKey:@"x"];
        double yValue = [CalculatorBrain runProgram:graphProgram usingVariableValues:variables];
        CGPoint graphPoint;
        graphPoint.x = xValue;
        graphPoint.y = yValue;
        self.graphPoints = [self.graphPoints arrayByAddingObject:graphPoint];
    }*/
    _graphView = graphView;
    self.graphView.dataSource = self;
    [self.graphView setNeedsDisplay];

}

- (CGPoint *)graphData:(GraphView *)sender{
    //allocate memory for CGPoint array (will change 320 to view width later
    CGPoint * points = (CGPoint*)malloc(320*sizeof(CGPoint));
    
    //same thing - need to change 320 to view width
    for (int index = 0; index <=320; index++) {    
    //rough in fake data for now...will replace with calculator program results
        points[index].x = index;
        points[index].y = index;
    }
    return(points);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload {
    [self setGraphView:nil];
    [super viewDidUnload];
}
@end
