//
// Created by Larusso on 17.04.14.
// Copyright (c) 2014 larusso. All rights reserved.
//

#import "LAMainWindow.h"
#import <Quartz/Quartz.h>

#define titleBarHeight 21.0


@implementation LAMainWindow


#pragma mark -
#pragma mark Custom Theme Drawing
+ (void)initialize
{
    // Make sure not to reinitialize for subclassed objects
    if (self != [LAMainWindow class])
        return;

    [NSWindow registerWindowClassForCustomThemeFrameDrawing:[LAMainWindow class]];
}

- (BOOL)drawsAboveDefaultThemeFrame
{
    return YES;
}

float ToolbarHeightForWindow(NSWindow *window)
{
    NSToolbar *toolbar;

    float toolbarHeight = 0.0;
    NSRect windowFrame;

    toolbar = [window toolbar];

    if (toolbar && [toolbar isVisible])
    {
        windowFrame = [NSWindow contentRectForFrameRect:[window frame] styleMask:[window styleMask]];
        toolbarHeight = NSHeight(windowFrame) - NSHeight([[window contentView] frame]);
    }

    return toolbarHeight;
}

- (void)drawThemeFrame:(NSRect)dirtyRect forWindow:(NSWindow *)window;
{
    if ([(LAMainWindow *) window isDrawCustomFrame])
    {
        float maxY = NSMaxY(dirtyRect);

        BOOL isInFullScreen = (([self styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask);
        BOOL hasToolbar = window.toolbar != nil;

        float titlebarHeight = titleBarHeight;

        if (hasToolbar)
        {
            titlebarHeight += ToolbarHeightForWindow(window);
        }

        if ((maxY > NSMaxY([self frame]) - titlebarHeight) && (!isInFullScreen))
        {
            float newHeight = [self frame].origin.y + [self frame].size.height - dirtyRect.origin.y - titlebarHeight;
            if (newHeight <= 0.0) return;
            dirtyRect.size.height = newHeight;
        }

        NSColor *startColor = [(LAMainWindow *) window fillColorStart];
        NSColor *endColor = [(LAMainWindow *) window fillColorEnd];

        NSGradient *fill = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
        [endColor set];
        NSRectFill(dirtyRect);
        //[fill drawInRect:dirtyRect angle:90];
    }
}

@end