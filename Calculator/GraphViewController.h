//
//  GraphViewController.h
//  Calculator
//
//  Created by Drew Rosenberg on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "splitViewBarButtonItemPresenter.h"

@class GraphViewController;

@protocol GraphViewControllerDelegate <NSObject>

-(void)graphViewController:(GraphViewController *)sender chooseProgram:(id)program;

@end

@interface GraphViewController : UIViewController <splitViewBarButtonItemPresenter>

@property (weak, nonatomic) id graphProgram;
@property (weak, nonatomic) id <GraphViewControllerDelegate> delegate;
@end
