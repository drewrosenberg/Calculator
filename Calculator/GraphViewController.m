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
@synthesize graphProgram = _graphProgram;

-(void) setGraphView:(GraphView*)graphView{
    _graphView = graphView;
    self.graphView.dataSource = self;
}

- (CGPoint *)graphData:(GraphView *)sender{
    //allocate memory for CGPoint array (will change 320 to view width later
    CGPoint * points = (CGPoint*)malloc(320*sizeof(CGPoint));
    
    //same thing - need to change 320 to view width
    for (int index = 0; index <=320; index++) {    
        NSDictionary * variables = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:index] forKey:@"x"];
        //rough in fake data for now...will replace with calculator program results
        //also need to match the axis labels
        points[index].x = index;
        points[index].y = [CalculatorBrain runProgram:self.graphProgram usingVariableValues:variables];
        NSLog(@"x=%@, y=%@\n",[NSNumber numberWithInt:index],[NSNumber numberWithDouble:points[index].y]);
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
