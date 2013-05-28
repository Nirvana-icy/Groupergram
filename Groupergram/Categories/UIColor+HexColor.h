//
//  UIColor+HexColor.h
//  Groupergram
//
//  Created by Kurry L Tran on 5/25/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
/** This category adds a set of methods to UIColor class. */

/** Returns an autoreleased UIColor instance with the hexadecimal color.
 
 @param hex A color in hexadecimal notation: `0xCCCCCC`, `0xF7F7F7`, etc.
 
 @return A new autoreleased UIColor instance. */
+ (UIColor *) colorWithHex:(int)hex;
@end
