//
// Created by Larusso on 24.05.13.
// Copyright (c) 2013 Larusso. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

struct LAResizeRects
{
    NSRect destinationRect;
    NSRect sourceRect;
};

typedef struct LAResizeRects LAResizeRects;

CG_INLINE LAResizeRects LAResizeRectsMake(NSRect sourceRect, NSRect destinationRect);

CG_INLINE LAResizeRects LAResizeRectsMake(NSRect sourceRect, NSRect destinationRect)
{
    LAResizeRects rects;
    rects.sourceRect = sourceRect;
    rects.destinationRect = destinationRect;
    return rects;
}

@interface NSImage (Resize)

typedef enum
{
    LAImageResizeCrop,
    LAImageResizeScale,
    LAImageResizeScaleHeight,
    LAImageResizeScaleWidth
} LAImageResizingMethod;

- (NSImage *)imageToFitSize:(NSSize)size method:(LAImageResizingMethod)resizeMethod;

- (NSImage *)imageCroppedToFitSize:(NSSize)size;

- (NSImage *)imageScaledToFitSize:(NSSize)size;

- (NSImage *)imageScaledToFitHeight:(NSSize)size;

- (NSImage *)imageScaledToFitWidth:(NSSize)size;

- (LAResizeRects)getResizeRectToFitSize:(NSSize)size withMethod:(LAImageResizingMethod)resizeMethod;

@end