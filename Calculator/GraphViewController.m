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
#import "CalculatorProgramTableViewController.h"

@interface GraphViewController () <GraphViewDataSource, CalculatorProgramsTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController
@synthesize toolbar = _toolbar;
@synthesize graphView = _graphView;
@synthesize graphProgram = _graphProgram;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

#define FAVORITES_KEY @"CalculatorGraphViewController.Favorites"

- (IBAction)addToFavorites:(id)sender {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorites = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
    if (!favorites) favorites = [NSMutableArray array];
    [favorites addObject:self.graphProgram];
    [defaults setObject:favorites forKey:FAVORITES_KEY];
    [defaults synchronize];
    NSLog(@"wrote favorite: %@\n",[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY]);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Favorite Graphs"]){
        NSArray *programs = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
        NSLog(@"loading programs to table view: %@",programs);
        [segue.destinationViewController setPrograms:programs];
        [segue.destinationViewController setDelegate:self];
        
    }
}

-(void) CalculatorProgramsTableViewController:(CalculatorProgramTableViewController *)sender chooseProgram:(id)program
{
    self.graphProgram = program;
}
    
-(void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem{
    if (_splitViewBarButtonItem != splitViewBarButtonItem){
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        //if it was present, remove it
        if (_splitViewBarButtonItem){
            [toolbarItems removeObject:_splitViewBarButtonItem];   
        }
        //if it will be present, add it
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

-(void) setGraphView:(GraphView*)graphView{
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    [self.graphView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(trippleTap:)]];
    self.graphView.dataSource = self;
}

-(void)setGraphProgram:(id)graphProgram
{
    if (graphProgram != _graphProgram) {
        _graphProgram = graphProgram;
        [self.graphView setNeedsDisplay];
    }
}

- (NSArray *)graphData:(GraphView *)sender
                InRect: (CGRect)rect
{
    NSMutableArray * points = [[[NSArray alloc] init] mutableCopy];
    CGFloat pointsPerUnit = self.graphView.viewScale;
    CGFloat xmin = -(self.graphView.origin.x/pointsPerUnit);
    CGFloat xmax = (rect.size.width-self.graphView.origin.x)/pointsPerUnit;
    CGFloat xstep = (xmax-xmin)/(rect.size.width*self.graphView.contentScaleFactor);
             
    for (CGFloat x = xmin; x <=xmax; x+=xstep) {  

        NSDictionary * variables = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:x] forKey:@"x"];
                
        float y = [CalculatorBrain runProgram:self.graphProgram usingVariableValues:variables];

        //if y is a valid value, plot it
        if (!isnan(y)){
            [points addObject:[NSValue valueWithCGPoint:
                               CGPointMake(self.graphView.origin.x + x*pointsPerUnit,
                                           self.graphView.origin.y - y*pointsPerUnit)]];
        }    

    }
  
    NSString *programDescription = [CalculatorBrain descriptionOfProgram:self.graphProgram];

    //add description of program to graph view unless in a split view
    if (![self splitViewController]){
        UIFont *font = [UIFont systemFontOfSize:12.0];
        [programDescription drawInRect:rect withFont:font];
    }
    return(points);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload {
    [self setGraphView:nil];
    [self setToolbar:nil];
    [self setToolbar:nil];
    [self setToolbar:nil];
    [super viewDidUnload];
}
@end
