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
        NSNumber * scale = [[NSUserDefaults standardUserDefaults] objectForKey:@"scale"];
        if (!scale){
            return DEFAULT_SCALE;
        }
        else{
            NSLog(@"read scale user default: %@\n",scale);
            return scale.floatValue;
        }
        
    }else {
        return _viewScale;
    }
}

-(CGPoint) origin{
    if (!_origin.x) {
        NSNumber * xOrigin = [[NSUserDefaults standardUserDefaults] objectForKey:@"x-origin"];
        NSLog(@"read origin.x user default: %@\n",xOrigin);
        NSNumber * yOrigin = [[NSUserDefaults standardUserDefaults] objectForKey:@"y-origin"];
        NSLog(@"read origin.x user default: %@\n",yOrigin);
        CGPoint defaultOrigin = CGPointMake(xOrigin.floatValue, yOrigin.floatValue);
        
        return defaultOrigin;
    }
    else return _origin;
}

-(void) setViewScale:(CGFloat)viewScale
{
    if (viewScale != _viewScale){
        _viewScale = viewScale;
        
        //load scale into user defaults
        NSUserDefaults * standardDefaults = [NSUserDefaults standardUserDefaults];
        if (standardDefaults){
            [standardDefaults setObject:[NSNumber numberWithFloat:viewScale] forKey:@"scale"];
            [standardDefaults synchronize];
            NSLog(@"wrote scale user default: %@\n",[[NSUserDefaults standardUserDefaults] objectForKey:@"scale"]);
        }

        [self setNeedsDisplay];
    }
}

-(void) setOrigin:(CGPoint)origin{
    if (!CGPointEqualToPoint(origin, _origin)){
        _origin = origin;

        //load origin into user defaults
        NSUserDefaults * standardDefaults = [NSUserDefaults standardUserDefaults];
        if (standardDefaults){
            [standardDefaults setObject:[NSNumber numberWithFloat:origin.x] forKey:@"x-origin"];
            [standardDefaults synchronize];
            NSLog(@"wrote origin.x user default: %@\n",[[NSUserDefaults standardUserDefaults] objectForKey:@"x-origin"]);
            [standardDefaults setObject:[NSNumber numberWithFloat:origin.y] forKey:@"y-origin"];
            NSLog(@"wrote origin.y user default: %@\n",[[NSUserDefaults standardUserDefaults] objectForKey:@"y-origin"]);
        }
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
        self.panActivated = YES; //don't center any more - set panActivated to yes
        [gesture setTranslation:CGPointZero inView:self];
    }
}


-(void) trippleTap:(UITapGestureRecognizer *)gesture
{
    gesture.numberOfTapsRequired = 3;
    if (gesture.state == UIGestureRecognizerStateEnded){
        self.panActivated = NO; //center again - set panActivated to no
    }
}

- (void)drawGraph:(CGContextRef) context
        InRect:(CGRect) bounds
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    [[UIColor blueColor] setStroke];
    
    NSArray *pointsArray = [self.dataSource graphData:self InRect:bounds];
    
    if ([pointsArray count] > 0){
        CGContextMoveToPoint(context, 
            [[pointsArray objectAtIndex:0]CGPointValue].x, 
            [[pointsArray objectAtIndex:0]CGPointValue].y);
    }

    //put graph points from controller on screen and draw lines between them
    for (int i=0; i<[pointsArray count]; i++) {
            CGContextAddLineToPoint(context, [[pointsArray objectAtIndex:i] CGPointValue].x, [[pointsArray objectAtIndex:i] CGPointValue].y);
    }
   
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
    if (!self.panActivated){
        self.origin = CGPointMake(rect.size.width/2, rect.size.height/2);        
    }
    
    //Draw Axes
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.viewScale];
    
    //get context
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Draw Graph
    [self drawGraph:context InRect:rect];
}


@end
