//
//  UAModalExampleView.h
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "UATitledModalPanel.h"

@interface GPPhotoModalPanel : UATitledModalPanel <UIGestureRecognizerDelegate>
{
	UIView *v;
}
- (id)initWithFrame:(CGRect)frame attributes:(NSDictionary *)attrs;
@end
