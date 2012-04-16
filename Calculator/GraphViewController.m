//
//  GraphViewController.m
//  Calculator
//
//  Created by Drew Rosenberg on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"

@interface GraphViewController ()
@property (weak, nonatomic) IBOutlet GraphView *graph;
@property NSString * equation;
@end

@implementation GraphViewController

@synthesize graph = _graph;
@synthesize equation = _equation;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == YES);
}

@end
