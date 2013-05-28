//
//  UIColor+HexColor.m
//  Groupergram
//
//  Created by Kurry L Tran on 5/25/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)
// http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
+ (UIColor *) colorWithHex:(int)hex {
  return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                         green:((float)((hex & 0xFF00) >> 8))/255.0
                          blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

@end
