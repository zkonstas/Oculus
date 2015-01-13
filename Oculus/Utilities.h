//
//  Utilities.h
//  Oculus
//
//  Created by Zissis Konstas on 5/5/14.
//  Copyright (c) 2014 Acme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstaPhoto.h"

@interface Utilities : NSObject

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (NSString *)timeAgo:(NSString *)time photoObject:(InstaPhoto *)photo;

@end
