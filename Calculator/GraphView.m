//
//  GraphView.m
//  Calculator
//
//  Created by Drew Rosenberg on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView
@synthesize dataSource = _dataSource;

-(void)setup{
    self.contentMode = UIViewContentModeRedraw;
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

- (void)drawRect:(CGRect)rect
{
    //get context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Draw Axes
    CGPoint origin;
    origin.x = rect.size.width / 2;
    origin.y = rect.size.height / 2;
    [AxesDrawer drawAxesInRect:rect originAtPoint:origin scale:10];
    [[UIColor blueColor] setStroke];

    
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, origin.x, rect.origin.y);

    //put graph points from controller on screen and draw lines between them
    NSArray *pointsArray = [self.dataSource graphData:self];
    int pointCount = [pointsArray count];
    CGPoint * points = malloc(pointCount*sizeof(CGPoint));
    for (int i=0; i<pointCount; i++) {
        points[i] = [[pointsArray objectAtIndex:i] CGPointValue];
    }
    CGContextAddLines(context, points, rect.size.width);
    free(points);
    
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}


@end
