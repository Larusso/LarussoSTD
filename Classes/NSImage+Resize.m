//
// Created by Larusso on 24.05.13.
// Copyright (c) 2013 Larusso. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSImage+Resize.h"

@implementation NSImage (Resize)

- (NSImage *)imageToFitSize:(NSSize)size withMethod:(LAImageResizingMethod)resizeMethod
{
    return [self imageToFitSize:size withMethod:resizeMethod andCrop:NO];
}

- (NSImage *)imageToFitSize:(NSSize)size withMethod:(LAImageResizingMethod)resizeMethod andCrop:(BOOL)crop
{
    LAResizeRects resizeRect = [self getResizeRectToFitSize:size withMethod:resizeMethod andCrop:crop];
    NSImage *result = [[NSImage alloc] initWithSize:resizeRect.destinationRect.size];

    // Composite image appropriately
    [result lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [self drawInRect:resizeRect.destinationRect fromRect:resizeRect.sourceRect operation:NSCompositeSourceOver fraction:1];
    [result unlockFocus];

    return result;
}


- (NSImage *)imageCroppedToFitSize:(NSSize)size
{
    return [self imageToFitSize:size withMethod:LAImageResizeCrop andCrop:YES];
}

- (NSImage *)imageScaledToFitSize:(NSSize)size
{

    return [self imageToFitSize:size withMethod:LAImageResizeScale andCrop:NO];
}

- (NSImage *)imageScaledToFitHeight:(NSSize)size
{
    return [self imageToFitSize:size withMethod:LAImageResizeScaleHeight andCrop:NO];
}

- (NSImage *)imageScaledToFitHeight:(NSSize)size andCropWidth:(BOOL)crop
{
    return [self imageToFitSize:size withMethod:LAImageResizeScaleHeight andCrop:crop];
}

- (NSImage *)imageScaledToFitWidth:(NSSize)size
{
    return [self imageToFitSize:size withMethod:LAImageResizeScaleWidth andCrop:NO];
}

- (NSImage *)imageScaledToFitWidth:(NSSize)size andCropHeight:(BOOL)crop
{
    return [self imageToFitSize:size withMethod:LAImageResizeScaleWidth andCrop:crop];
}


#pragma mark - utility methods

- (LAResizeRects)getResizeRectToFitSize:(NSSize)size withMethod:(LAImageResizingMethod)resizeMethod andCrop:(BOOL)crop;
{
    float sourceWidth = [self size].width;
    float sourceHeight = [self size].height;
    float targetWidth = size.width;
    float targetHeight = size.height;

    NSRect destinationRect;
    NSRect sourceRect;
    float factorWidth = targetWidth / sourceWidth;
    float factorHeight = targetHeight / sourceHeight;

    if (resizeMethod == LAImageResizeScale)
    {
        destinationRect.size.width = (factorWidth >= factorHeight) ? sourceWidth * factorHeight : targetWidth;
        destinationRect.size.height = (factorHeight < factorWidth) ? targetHeight : sourceHeight * factorWidth;
        destinationRect.origin.x = 0;
        destinationRect.origin.y = 0;

        sourceRect = CGRectMake(0, 0, sourceWidth, sourceHeight);
    }

    if (resizeMethod == LAImageResizeScaleWidth)
    {
        destinationRect.size.width = targetWidth;
        destinationRect.size.height = sourceHeight * factorWidth;

        if (crop)
        {
            destinationRect.size.height = MIN(destinationRect.size.height, targetHeight);
        }

        destinationRect.origin.x = 0;
        destinationRect.origin.y = 0;

        sourceRect = CGRectMake(0, 0, sourceWidth, targetHeight * factorWidth);

    }

    if (resizeMethod == LAImageResizeScaleHeight)
    {
        destinationRect.size.width = sourceWidth * factorHeight;
        destinationRect.size.height = targetHeight;
        destinationRect.origin.x = 0;
        destinationRect.origin.y = 0;

        if (crop)
        {
            destinationRect.size.width = MIN(destinationRect.size.width, targetWidth);
        }

        sourceRect = CGRectMake(0, 0, targetWidth * factorHeight, sourceHeight);
    }
    return LAResizeRectsMake(sourceRect, destinationRect);
}

@end