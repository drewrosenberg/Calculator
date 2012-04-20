//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Andrew Rosenberg on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *display;
@end
