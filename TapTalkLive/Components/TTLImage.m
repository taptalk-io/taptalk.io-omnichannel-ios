//
//  TTLImage.m
//  TapTalkLive
//
//  Created by Dominic Vedericho on 18/01/20.
//  Copyright © 2020 taptalk.io. All rights reserved.
//

#import "TTLImage.h"

@implementation TTLImage

- (UIImage *)setImageTintColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self drawInRect:rect];
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    CGContextSetBlendMode(contextRef, kCGBlendModeSourceAtop);
    CGContextFillRect(contextRef, rect);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end
