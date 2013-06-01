//
//  SwipePageWidgetView.m
//  EGCoreFrameworkDemo
//
//  Created by feng guanhua on 13-5-28.
//  Copyright (c) 2013年 feng guanhua. All rights reserved.
//

#import "SwipePageWidgetView.h"
#import "EGCore/EGBasicAnimation.h"

@implementation WidgetImage
@synthesize image, frame;
@end

@implementation WidgetParams
@synthesize imagelist, durnation, destinationX, delay;
-(id) initWithParams:(CGRect)rect destX:(int)x image:(NSString*)name durnation:(float)dur delay:(float)del
{
    self = [super init];
    self.destinationX = x;
    WidgetImage *image = [[WidgetImage alloc] init];
    image.image = name;
    image.frame = rect;
    self.imagelist = [[NSArray alloc] initWithObjects:image,nil];
    self.durnation = dur;
    self.delay = del;
    return self;
}


-(id) initWithParams:(NSArray*)images destX:(int)x durnation:(float)dur delay:(float)del
{
    self = [super init];
    self.destinationX = x;
    self.imagelist = images;
    self.durnation = dur;
    self.delay = del;
    return self;
}

@end


@implementation SwipePageWidgetView
@synthesize imageViewLists, destinationX, durnation, delay;
;

- (id)initWithParams:(CGRect)widgetFrame destX:(int)x image:(NSString*)name durnation:(float)dur delay:(float)del withMainViewFrame:(CGRect)mainFrame ofType:(WidgetType)type
{
    self = [super initWithFrame:mainFrame];
    if (self) {
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        imageview.frame = widgetFrame;
        [self addSubview:imageview];
        widgetType = type;
        destinationX = x;
        durnation = dur;
        delay = del;
        if( type == WIDGET_ANIMATION || type == WIDGET_ANIMATION_SWIPING ){
            [self animate];
        }
    }
    return self;
}


- (void)swipeViewDidScroll:(float)offset withIndex:(int) index
{
    if( widgetType == WIDGET_ANIMATION ) return;
    CGRect rect = self.frame;
    float val = offset - index;
    rect.origin.x = destinationX- val*1000;
    self.frame = rect;
    NSLog(@"x=%f, offset=%f", rect.origin.x, offset );
}


-(void) animate
{
    [EGBasicAnimation moveX:destinationX duration:durnation delay:delay withView:self];
}


@end