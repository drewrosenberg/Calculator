//
//  CalculatorProgramTableViewController.m
//  Calculator
//
//  Created by Drew Rosenberg on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorProgramTableViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorProgramTableViewController ()

@end

@implementation CalculatorProgramTableViewController
@synthesize programs = _programs;
@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.programs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Calculator Program Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    id program = [self.programs objectAtIndex:indexPath.row];
    cell.textLabel.text = [@"y= " stringByAppendingString:[CalculatorBrain descriptionOfProgram:program]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
#define FAVORITES_KEY @"CalculatorGraphViewController.Favorites"
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSMutableArray * mutablePrograms = [self.programs mutableCopy];
        [mutablePrograms removeObject:[mutablePrograms objectAtIndex:indexPath.row]];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        self.programs = mutablePrograms;

        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *favorites = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
        if (!favorites) favorites = [NSMutableArray array];
        [favorites removeObject:[favorites objectAtIndex:indexPath.row]];
        [defaults setObject:favorites forKey:FAVORITES_KEY];
        [defaults synchronize];
        NSLog(@"removed favorite: %@\n",[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY]);

        [self.tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id program = [self.programs objectAtIndex:indexPath.row];
    [self.delegate CalculatorProgramsTableViewController:self chooseProgram:program];
}

@end
