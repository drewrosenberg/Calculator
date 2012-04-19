//
//  GraphView.m
//  Calculator
//
//  Created by Drew Rosenberg on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

#define DEFAULT_SCALE 10

@implementation GraphView
@synthesize dataSource = _dataSource;
@synthesize viewScale = _viewScale;

-(void)setup{
    self.contentMode = UIViewContentModeRedraw;
}

-(CGFloat) viewScale{
    if (!_viewScale) {
        return DEFAULT_SCALE;
    }else {
        return _viewScale;
    }
}

-(void) setViewScale:(CGFloat)viewScale
{
    if (viewScale != _viewScale){
        _viewScale = viewScale;
        [self setNeedsDisplay];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(void) awakeFromNib{
    [self setup];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded))
    {
        self.viewScale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)drawGraph:(CGContextRef) context
        InRect:(CGRect) bounds
        originatPoint:(CGPoint)axisOrigin
        scale:(CGFloat)pointsPerUnit
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    [[UIColor blueColor] setStroke];
    
    NSArray *pointsArray = [self.dataSource graphData:self InRect:bounds originAtPoint:axisOrigin withScale:pointsPerUnit];
    
    CGContextMoveToPoint(context, 
                [[pointsArray objectAtIndex:0]CGPointValue].x, 
                [[pointsArray objectAtIndex:0]CGPointValue].y);
    
    int pointCount = [pointsArray count];
    //put graph points from controller on screen and draw lines between them
    for (int i=0; i<pointCount; i++) {
        CGContextAddLineToPoint(context, [[pointsArray objectAtIndex:i] CGPointValue].x, [[pointsArray objectAtIndex:i] CGPointValue].y);
    }
   
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}
- (void)drawRect:(CGRect)rect
{
    //get context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint origin;
    origin.x = rect.size.width / 2;
    origin.y = rect.size.height / 2;

    //Draw Axes
    [AxesDrawer drawAxesInRect:rect originAtPoint:origin scale:self.viewScale];
    
    [self drawGraph:context InRect:rect originatPoint:origin scale:self.viewScale];    
}


@end
