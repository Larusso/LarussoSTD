//
// Created by Larusso on 17.04.14.
// Copyright (c) 2014 larusso. All rights reserved.
//

#import "NSWindow+LACustomWindow.h"
#import <objc/objc-runtime.h>

@interface NSWindow (OEOriginalThemeFrameDrawing)
- (void)drawRectOriginal:(NSRect)dirtyRect;
@end

@implementation NSWindow (LACustomWindow)

+ (void)registerWindowClassForCustomThemeFrameDrawing:(Class)windowClass
{
    static BOOL customDrawingWasSetup = NO;
    Class NSThemeFrameClass = NSClassFromString(@"NSThemeFrame");

    if (customDrawingWasSetup == NO)
    {
        customDrawingWasSetup = YES;

        // exchange method implementation of NSThemeFrame's drawRect:
        Method customDrawingMethod = class_getInstanceMethod([NSWindow class], @selector(drawThemeFrame:));
        IMP customDrawingImplementation = method_getImplementation(customDrawingMethod);

        Method originalDrawingMethod = class_getInstanceMethod(NSThemeFrameClass, @selector(drawRect:));
        const char *typeEncoding = method_getTypeEncoding(originalDrawingMethod);

        // make original implementation of drawRect: available as drawRectOriginal:
        class_addMethod(NSThemeFrameClass, @selector(drawRectOriginal:), customDrawingImplementation, typeEncoding);
        Method customDrawingMethodOnThemeFrame = class_getInstanceMethod(NSThemeFrameClass, @selector(drawRectOriginal:));
        method_exchangeImplementations(originalDrawingMethod, customDrawingMethodOnThemeFrame);
    }

    // add instance method drawRect: of themeViewClass to instances of NSThemeFrameClass
    NSString *winodwClassName = NSStringFromClass(windowClass);
    NSString *selectorName = [NSString stringWithFormat:@"draw%@ThemeRect:", winodwClassName];
    SEL newDrawingSelector = NSSelectorFromString(selectorName);

    Method themeDrawingMethod = class_getInstanceMethod(windowClass, @selector(drawThemeFrame:forWindow:));
    IMP themeDrawingImplementation = method_getImplementation(themeDrawingMethod);
    const char *typeEncoding = method_getTypeEncoding(themeDrawingMethod);

    class_addMethod(NSThemeFrameClass, newDrawingSelector, themeDrawingImplementation, typeEncoding);
}

- (void)drawThemeFrame:(NSRect)dirtyRect
{
    id window = [(NSView *) self window];

    BOOL drawingCustomWindow = [window conformsToProtocol:@protocol(LACustomWindow)];
    if (!drawingCustomWindow || [window drawsAboveDefaultThemeFrame])
    {
        [self drawRectOriginal:dirtyRect];
    }
    if (drawingCustomWindow)
    {
        // create drawing selector based on window class
        NSString *windowClassName = NSStringFromClass([window class]);
        NSString *selectorName = [NSString stringWithFormat:@"draw%@ThemeRect:", windowClassName];
        SEL customDrawingSelector = NSSelectorFromString(selectorName);

        // finally draw the custom theme frame
        ((void ( *)(id, SEL, NSRect, id )) objc_msgSend)(self, customDrawingSelector, dirtyRect, window);
    }
}

@end