//
//  SwipePageWidgetView.m
//  EGCoreFrameworkDemo
//
//  Created by feng guanhua on 13-5-28.
//  Copyright (c) 2013年 feng guanhua. All rights reserved.
//

#import "SwipePageWidgetView.h"
#import "EGCore/EGBasicAnimation.h"
#import "EGCore/EGReflection.h"
#import "AppDataSource.h"

@implementation SwipePageWidgetView
@synthesize reflectionInfo;

- (id)initWithParams:(CGRect)widgetFrame dest:(int)xy animateType:(AnimationType)atype image:(NSString*)name durnation:(float)dur delay:(float)del withMainViewFrame:(CGRect)mainFrame ofType:(WidgetType)wtype
{
    self = [super initWithFrame:mainFrame];
    if (self) {
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        imageview.frame = widgetFrame;
        [self addSubview:imageview];
        widgetType = wtype;
        destination = xy;
        duration = dur;
        animationType = atype;
        delay = del;
        if( widgetType == WIDGET_ANIMATION || widgetType == WIDGET_ANIMATION_SWIPING ){
            [self animate];
        }
    }
    return self;
}


- (void)toDestination:(NSDictionary *)to
{
    if( !to ) return;
    NSString *tox = [to objectForKey:@"x"];
    if( tox.length == 0 ){
        NSString *toy = [to objectForKey:@"y"];
        assert(toy.length > 0);
        animationType = MOVE_Y;
        destination = [toy integerValue];
    } else {
        animationType = MOVE_X;
        destination = [tox integerValue];
    }
}


-(BOOL) addImagePerfrom:(NSString*)image withFrame:(CGRect)frame withDict:(NSDictionary *)dict
{
    reflectionInfo = [dict objectForKey:@"perform"];
    if( !reflectionInfo ) return FALSE;
    UIButton *button = [Constant addButton:frame withImage:image inView:self];
    [button addTarget:self action:@selector(reflection) forControlEvents:UIControlEventTouchUpInside];
    return TRUE;
}



-(void) reflection
{
    NSString *class = [reflectionInfo objectForKey:@"class"];
    NSString *func  = [reflectionInfo objectForKey:@"function"];
    NSDictionary *param = [reflectionInfo objectForKey:@"parameters"];
    [EGReflection performSelector:func ofClass:class withParam:param];
}



- (id)initWithJsonDict: (NSDictionary *)dict
{
    NSArray *frame = [dict objectForKey:@"frame"];
    CGRect ret = [SwipePageWidgetView createCGRectByDict:frame];
    self = [super initWithFrame:ret];
    
    self.name =  [dict objectForKey:@"name"];
    NSString *image = [dict objectForKey:@"image"];
    NSDictionary *pos = [dict objectForKey:@"position"];
    NSArray *from     = [pos objectForKey:@"from"];
    CGRect imageFrame   = [SwipePageWidgetView createCGRectByDict:from];
    bool isExist = [self addImagePerfrom:image withFrame:imageFrame withDict:dict];
    if( !isExist ){
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        imageview.frame = imageFrame;
        [self addSubview:imageview];
    }
    
    [self toDestination: [pos objectForKey:@"to"]];
    NSString *dur = [dict objectForKey:@"duration"];
    if(dur) duration = [dur floatValue];
    NSString *del = [dict objectForKey:@"delay"];
    if(del) delay = [del floatValue];
    
    widgetType = [SwipePageWidgetView widgetTypeFromDict: dict];
    if( widgetType == WIDGET_ANIMATION || widgetType == WIDGET_ANIMATION_SWIPING ){
        [self animate];
    }
    return self;
}


+(SwipePageWidgetView*) addWidgetView:(CGRect)widgetFrame toDestX:(int)x animateType:(AnimationType)atype withImage:(NSString*)image durcation:(float)dur delay:(float)time ofType:(WidgetType)type withMainViewFrame:(CGRect)mainFrame inView:(UIView *)view
{
    SwipePageWidgetView *widget = [[SwipePageWidgetView alloc] initWithParams:widgetFrame dest:x animateType:atype image:image durnation:dur delay:time withMainViewFrame:mainFrame ofType:type];
    [view addSubview:widget];
    return widget;
}


+(SwipePageWidgetView*) initWithJsonDict:(NSDictionary *)dict inView:(UIView *)view
{
    SwipePageWidgetView *widget = [[SwipePageWidgetView alloc] initWithJsonDict:dict];
    [view addSubview:widget];
    return widget;
}


+(CGRect) createCGRectByDict:(NSArray*)dict
{
    NSInteger x =  [[dict objectAtIndex:0] integerValue];
    NSInteger y =  [[dict objectAtIndex:1] integerValue];
    NSInteger w =  [[dict objectAtIndex:2] integerValue];
    NSInteger h =  [[dict objectAtIndex:3] integerValue];
    return CGRectMake(x,y,w,h);
}



+(WidgetType) widgetTypeFromDict:(NSDictionary*)dict
{
    NSString *type = [dict objectForKey:@"type"];
    if( [type isEqualToString:KEY_IMAGE])       return WIDGET_STATIC_IMAGE;
    if( [type isEqualToString:KEY_SWIPIING])    return WIDGET_SWIPING;
    if( [type isEqualToString:KEY_ANIMATION] )  return WIDGET_ANIMATION;
    return WIDGET_ANIMATION_SWIPING;
}


- (void)swipeViewDidScroll:(float)offset withIndex:(int) index
{
    if( widgetType == WIDGET_SWIPING || widgetType ==  WIDGET_ANIMATION_SWIPING ){
        CGRect rect = self.frame;
        float val = offset - index;
        rect.origin.x = destination- val*1000;
        self.frame = rect;
    }
//    NSLog(@"x=%f, offset=%f", rect.origin.x, offset );
}


-(void) animate
{
    if( animationType == MOVE_X )
        [EGBasicAnimation moveX:destination duration:duration delay:delay withView:self];
    else
        [EGBasicAnimation moveY:destination duration:duration delay:delay withView:self];
}


@end
