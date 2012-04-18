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
    [self.graphView setNeedsDisplay];
}

- (NSArray *)graphData:(GraphView *)sender{
    NSArray * points = [[NSArray alloc] init];
    
    //same thing - need to change 320 to view width
    for (int index = 0; index <=320; index++) {  
        NSDictionary * variables = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:index] forKey:@"x"];

        //still need to match the axis labels
        points = 
            [points arrayByAddingObject:
             [NSValue valueWithCGPoint:
                CGPointMake(
                    index, 
                    [CalculatorBrain runProgram:self.graphProgram usingVariableValues:variables]
                    )
              ]
            ];
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
