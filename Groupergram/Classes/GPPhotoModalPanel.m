//
//  UAModalExampleView.m
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "GPPhotoModalPanel.h"
#import "UIColor+HexColor.h"
#import "UIImageView+WebCache.h"
@implementation GPPhotoModalPanel

- (id)initWithFrame:(CGRect)frame attributes:(NSDictionary *)attrs
{
	if ((self = [super initWithFrame:frame])) {
    [self.titleBar setFrame:CGRectZero];
    self.headerLabel = nil;
    NSDictionary *images = [attrs objectForKey:@"images"];
    NSArray *tags = [attrs objectForKey:@"tags"];
    NSString *labelText = @"";
    for (NSString *tag in tags)
    { 
      labelText = [labelText stringByAppendingString:[NSString stringWithFormat:@"#%@ ",tag]];
    }

    NSString *imageURL = [images valueForKeyPath:@"standard_resolution.url"];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 306, 306)];
		[iv setImageWithURL:[NSURL URLWithString:imageURL]];
		[iv setContentMode:UIViewContentModeScaleAspectFit];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 436, self.bounds.size.width-16, 0)];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = labelText;
    [label sizeToFit];
    self.margin = UIEdgeInsetsMake(0,8,0,8);
		self.padding = UIEdgeInsetsMake(0,8,0,8);
    self.borderColor = [UIColor clearColor];
		NSArray *contentArray = [NSArray arrayWithObjects:iv, nil];
		v = [contentArray objectAtIndex:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.contentView addGestureRecognizer:tap];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:label];
		[self.contentView addSubview:v];
	}	
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];	
	[v setFrame:self.contentView.bounds];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
  if (sender.state == UIGestureRecognizerStateEnded)
  {
    [self removeFromSuperview];
  }
}


@end
