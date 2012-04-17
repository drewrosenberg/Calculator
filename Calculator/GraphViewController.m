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
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (nonatomic, strong) NSArray * graphProgram;
@end

@implementation GraphViewController
@synthesize graphProgram = _graphProgram;
@synthesize graphView = _graphView;

-(NSArray*) graphProgram{
    if (_graphProgram == nil){
        _graphProgram = [[NSArray alloc] init];
    }
    return _graphProgram;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == YES);
}

@end
