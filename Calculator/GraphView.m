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
    CGPoint * points = malloc(pointCount*sizeof(CGPoint));
    for (int i=0; i<pointCount; i++) {
        points[i] = [[pointsArray objectAtIndex:i] CGPointValue];
        //NSLog(@"x=%@, y=%@", points[i].x, points[i].y);
    }
    CGContextAddLines(context, points, bounds.size.height);
    free(points);
    
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}
- (void)drawRect:(CGRect)rect
{
    //get context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Draw Axes
    CGPoint origin;
    origin.x = rect.size.width / 2;
    origin.y = rect.size.height / 2;
    [AxesDrawer drawAxesInRect:rect originAtPoint:origin scale:10];
    
    [self drawGraph:context InRect:rect originatPoint:origin scale:self.viewScale];
}


@end
