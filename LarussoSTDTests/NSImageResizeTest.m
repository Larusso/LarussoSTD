//
// Created by Larusso on 28.05.13.
// Copyright (c) 2013 larusso. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//
#define NELEMS(x)  (sizeof(x) / sizeof(x[0]))

#import <SenTestingKit/SenTestingKit.h>
#import "NSImageResizeTest.h"
#import "NSImage+Resize.h"

@implementation NSImageResizeTest

- (void)setUp
{
    [super setUp];

    NSBundle *unitTestBundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [unitTestBundle pathForResource:@"image_40_50" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];

    self.instance = [[NSImage alloc] initWithData:imageData];
}

- (void)tearDown
{
    self.instance = nil;

    [super tearDown];
}

- (void)testScaleToFitDown
{
    //40_50
    NSSize testSizes[] = {CGSizeMake(20, 30), CGSizeMake(10, 80), CGSizeMake(50, 50), CGSizeMake(40, 20)};
    NSSize testResults[] = {CGSizeMake(20, 30), CGSizeMake(10, 80), CGSizeMake(50, 50), CGSizeMake(40, 20)};
    NSImage *resizedImage;
    int i;
    for (i = 0; i < NELEMS(testSizes); i++)
    {
        NSSize testSize = testSizes[i];
        resizedImage = [self.instance imageScaledToFitSize:testSize];
        STAssertNotNil(resizedImage, @"should return a image object");
        STAssertTrue([resizedImage size].width <= testSize.width, @"width should be smaller or equal than %d", testSize.width);
        STAssertTrue([resizedImage size].height <= testSize.height, @"image height should be smaller or equal than %d", testSize.height);
    }
    resizedImage = nil;
}

- (void)testScaleToFitHeight
{
    NSSize testSizes[] = {CGSizeMake(20, 30), CGSizeMake(10, 80), CGSizeMake(50, 50), CGSizeMake(40, 20)};
    NSImage *resizedImage;
    int i;
    for (i = 0; i < NELEMS(testSizes); i++)
    {
        NSSize testSize = testSizes[i];
        resizedImage = [self.instance imageScaledToFitHeight:testSize];
        STAssertNotNil(resizedImage, @"should return a image object");
        STAssertEquals(resizedImage.size.height, testSize.height, nil);
        STAssertEquals(resizedImage.size.width, testSize.width, nil);
    }
    resizedImage = nil;
}

@end