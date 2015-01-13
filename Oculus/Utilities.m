//
//  Utilities.m
//  Oculus
//
//  Created by Zissis Konstas on 5/5/14.
//  Copyright (c) 2014 Acme. All rights reserved.
//

#import "Utilities.h"
#import "InstaPhoto.h"

@implementation Utilities


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//Get time ago

+(NSString *)timeAgo:(NSString *)time photoObject:(InstaPhoto *)photo {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeInterval _interval= time.doubleValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    // set the appropriate format in this string
    //NSLog(@"Time Ago: %@", time);
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    NSString *timeAgo = date.shortTimeAgoSinceNow;
    
    //Assign time to Photo object
    photo.time = timeAgo;
    
    return timeAgo;
}

@end
