//
//  GraphViewController.h
//  Calculator
//
//  Created by Drew Rosenberg on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "splitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <splitViewBarButtonItemPresenter>

@property (weak, nonatomic) id graphProgram;
@end
