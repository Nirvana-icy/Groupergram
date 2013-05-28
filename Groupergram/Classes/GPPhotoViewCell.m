//
//  GPGridViewCell.m
//  Groupergram
//
//  Created by Kurry L Tran on 5/25/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import "GPPhotoViewCell.h"
#import "UIColor+HexColor.h"

static UIFont *titleFont = nil;
static UIFont *subTitleFont = nil;
static UIColor *default_color = nil;
static UIColor *default_text_color = nil;

@interface GPPhotoViewCell ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) UIImage *image;
@end

@implementation GPPhotoViewCell

+ (void) initialize
{
  titleFont = [UIFont fontWithName:@"ProximaNova-Bold" size:22];
  subTitleFont =[UIFont fontWithName:@"ProximaNova-Bold" size:18];
  default_color = [UIColor colorWithHex:0x072933];
  default_text_color = [UIColor colorWithHex:0x135a6e];
}

- (void)setTitle:(NSString*)title subTitle:(NSString*)subTitle image:(UIImage *)image
{
  if (self.title != title)
    self.title = title;
  
  if (self.subTitle != subTitle)
    self.subTitle = subTitle;
  
  if (self.image != image)
    self.image = image;
        
  [self setNeedsDisplay];
}

-(void)drawContentView:(CGRect)r
{
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, default_color.CGColor);
  CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
  CGContextSetFillColorWithColor(context, default_text_color.CGColor);
  
  [default_text_color set];

  [self.image drawInRect:CGRectMake(4, 4, 140, 140)];
  
  [_title drawAtPoint:CGPointMake(87.0f, 150.0f)
             forWidth:100
             withFont:titleFont
             fontSize:22
        lineBreakMode:NSLineBreakByTruncatingTail
   baselineAdjustment:UIBaselineAdjustmentAlignCenters];
  
  [_subTitle drawAtPoint:CGPointMake(4.0f, 153.0f)
                forWidth:100
                withFont:subTitleFont
                fontSize:18
           lineBreakMode:NSLineBreakByTruncatingTail
      baselineAdjustment:UIBaselineAdjustmentAlignCenters];
}

@end
