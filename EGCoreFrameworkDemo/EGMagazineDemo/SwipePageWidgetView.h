//
//  SwipePageWidgetView.h
//  EGCoreFrameworkDemo
//
//  Created by feng guanhua on 13-5-28.
//  Copyright (c) 2013年 feng guanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WIDGET_SWIPING,
    WIDGET_ANIMATION,
    WIDGET_ANIMATION_SWIPING,
}WidgetType;


@interface WidgetImage: NSObject
@property (nonatomic, strong) NSString *image;
@property (nonatomic) CGRect frame;
@end



@interface SwipePageWidgetView : UIView{
    WidgetType widgetType;
}
@property (nonatomic, strong) NSMutableArray *imageViewLists;
@property (nonatomic) int   destinationX;
@property (nonatomic) float durnation;
@property (nonatomic) float delay;

- (id)initWithParams:(CGRect)widgetFrame destX:(int)x image:(NSString*)name durnation:(float)dur delay:(float)del withMainViewFrame:(CGRect)mainFrame ofType:(WidgetType)type;

- (void)swipeViewDidScroll:(float)offset withIndex:(int) index;
@end

