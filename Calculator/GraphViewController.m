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

- (NSArray *)graphData:(GraphView *)sender
                InRect: (CGRect)rect
         originAtPoint: (CGPoint) origin
             withScale: (CGFloat) pointsPerUnit
{
    NSArray * points = [[NSArray alloc] init];
    
    CGFloat xmin = -(origin.x/pointsPerUnit);
    CGFloat xmax = (rect.size.width-origin.x)/pointsPerUnit;
    CGFloat xstep = (xmax-xmin)/rect.size.width;
    
    for (CGFloat x = xmin; x <=xmax; x+=xstep) {  
        
        NSDictionary * variables = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:x] forKey:@"x"];
        float y = [CalculatorBrain runProgram:self.graphProgram usingVariableValues:variables];
        
        //still need to match the axis labels
        points = 
            [points arrayByAddingObject:
             [NSValue valueWithCGPoint:
                CGPointMake(
                    origin.x + x*pointsPerUnit, 
                    origin.y + y*pointsPerUnit
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
