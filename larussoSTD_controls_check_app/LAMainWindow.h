//
// Created by Larusso on 17.04.14.
// Copyright (c) 2014 larusso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSWindow+LACustomWindow.h"

@interface LAMainWindow : NSWindow <LACustomWindow>
@property(nonatomic, strong) NSColor *fillColorStart;
@property(nonatomic, strong) NSColor *fillColorEnd;
@property(nonatomic, assign) BOOL isDrawCustomFrame;
@end


@interface LAMainWindow (color_attributes)
@end