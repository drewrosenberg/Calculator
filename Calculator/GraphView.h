//
//  GraphView.h
//  Calculator
//
//  Created by Drew Rosenberg on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource
-(CGPoint *) graphData:(GraphView *) sender; //array of NSValues NSValueWithCGPoint
@end

@interface GraphView : UIView
@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@end
