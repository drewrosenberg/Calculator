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
-(NSArray *) graphData:(GraphView *) sender
                InRect: (CGRect)rect;
//array of NSValues NSValueWithCGPoint
@end

@interface GraphView : UIView
@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@property (nonatomic) CGFloat viewScale;
@property (nonatomic) CGPoint origin;

-(void)pinch:(UIPinchGestureRecognizer *)gesture;
-(void)pan:(UIPanGestureRecognizer *)gesture;
-(void)trippleTap:(UITapGestureRecognizer *)gesture;
@end
