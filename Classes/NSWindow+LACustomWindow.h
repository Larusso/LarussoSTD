//
// Created by Larusso on 17.04.14.
// Copyright (c) 2014 larusso. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LACustomWindow <NSObject>
- (BOOL)drawsAboveDefaultThemeFrame;
- (void)drawThemeFrame:(NSRect)dirtyRect forWindow:(NSWindow *)scope;
@end

@interface NSWindow (LACustomWindow)
+ (void)registerWindowClassForCustomThemeFrameDrawing:(Class)windowClass;
@end