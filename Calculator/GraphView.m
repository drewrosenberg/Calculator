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
@interface GraphView()
@property (nonatomic) BOOL panActivated;
@end

@implementation GraphView
@synthesize dataSource = _dataSource;
@synthesize viewScale = _viewScale;
@synthesize origin = _origin;
@synthesize panActivated = _panActivated;

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

-(void) setOrigin:(CGPoint)origin{
    if (!CGPointEqualToPoint(origin, _origin)){
        _origin = origin;
        [self setNeedsDisplay];
    }
}

-(void) setPanActivated:(BOOL)panActivated{
    if (_panActivated != panActivated){
        _panActivated = panActivated;
        if (panActivated == NO){
            [self setNeedsDisplay];
        }
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

-(void) pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded))
    {
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x+translation.x, self.origin.y+translation.y);
        self.panActivated = YES;
        [gesture setTranslation:CGPointZero inView:self];
    }
}


-(void) trippleTap:(UITapGestureRecognizer *)gesture
{
    gesture.numberOfTapsRequired = 3;
    if (gesture.state == UIGestureRecognizerStateEnded){
        self.panActivated = NO;
    }
}

- (void)drawGraph:(CGContextRef) context
        InRect:(CGRect) bounds
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    [[UIColor blueColor] setStroke];
    
    NSArray *pointsArray = [self.dataSource graphData:self InRect:bounds];
    
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
    
    if (!self.panActivated){
        self.origin = CGPointMake(rect.size.width/2, rect.size.height/2);        
    }
    
    //Draw Axes
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.viewScale];
    
    [self drawGraph:context InRect:rect];    
}


@end
