//
//  CalculatorProgramTableViewController.h
//  Calculator
//
//  Created by Drew Rosenberg on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorProgramTableViewController;

@protocol CalculatorProgramsTableViewControllerDelegate <NSObject>
@optional -(void)CalculatorProgramsTableViewController:(CalculatorProgramTableViewController *)sender
                               chooseProgram:(id)program;
-(void)CalculatorProgramsTableViewController:(CalculatorProgramTableViewController *)sender 
                         deleteFromFavorites:(NSArray *)programs;
@end

@interface CalculatorProgramTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *programs; //of calculatorBrain Programs
@property (nonatomic, weak) id <CalculatorProgramsTableViewControllerDelegate> delegate;
@end
