//
//  ViewController.m
//  Groupergram
//
//  Created by Kurry L Tran on 5/25/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationBar+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UIColor+HexColor.h"
#import "GMGridView.h"
#import "GPPhotoViewCell.h"
#import "AFJSONRequestOperation.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "GPPhotoModalPanel.h"

NSString *const kInstagramImagesDidLoadNotification = @"Instagram Images Did Load";
NSString *const kInstagramImagesDidFailNotification = @"Instagram Images Did Fail";
NSString *const kNextURLKey = @"pagination.next_url";
NSString *const kErrorKey = @"Error";
NSString *const kResponseKey = @"Response";

@interface ViewController ()<GMGridViewDataSource,GMGridViewActionDelegate, UIScrollViewDelegate>
{
  NSMutableArray *_currentData;
  GMGridView *_gmGridView;

}
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSString *nextURL;
@end

@implementation ViewController

- (void)loadData:(NSURLRequest *)request
{
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[JSON valueForKeyPath:kNextURLKey] forKey:kNextURLKey];
    NSArray *objects = [JSON valueForKeyPath:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kInstagramImagesDidLoadNotification object:objects userInfo:userInfo];
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[error debugDescription] forKey:kErrorKey];
    [userInfo setObject:request.debugDescription forKey:kResponseKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kInstagramImagesDidLoadNotification object:nil userInfo:userInfo];
  }];
  [self.operationQueue addOperation:operation];
}

- (void)loadNextPage
{
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.nextURL]];
  [self loadData:request];
}

- (void)imageLoadSuccess:(NSNotification *)notification
{
  [self.activityView stopAnimating];
  self.nextURL = [notification.userInfo objectForKey:kNextURLKey];
  [_currentData addObjectsFromArray:notification.object];
  dispatch_async(dispatch_get_main_queue(), ^{
    [_gmGridView reloadData];
  });
}

- (void)imageLoadFailure:(NSNotification *)notification
{
  NSLog(@"Response:%@ Error:%@",[notification.userInfo objectForKey:kResponseKey],[notification.userInfo objectForKey:kErrorKey]);
}

#pragma mark -
#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{ 
  CGPoint offset = scrollView.contentOffset;
  CGRect bounds = scrollView.bounds;
  CGSize size = scrollView.contentSize;
  UIEdgeInsets inset = scrollView.contentInset;
  float y = offset.y + bounds.size.height - inset.bottom;
  float h = size.height;
  float reload_distance = -self.view.bounds.size.height;
  if(y > h + reload_distance && self.operationQueue.operationCount <= 2) {
    [self loadNextPage];
  }
}

#pragma mark -
#pragma mark GMGridViewDataSource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
  return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
  return CGSizeMake(148, 180);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
  NSDictionary *data = [_currentData objectAtIndex:index];
  NSDictionary *images = [data objectForKey:@"images"];
  CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
  GPPhotoViewCell *cell = (GPPhotoViewCell *)[gridView dequeueReusableCell];
  
  if (cell == nil)
    cell = [[GPPhotoViewCell alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
  
  NSString *imageURL = [images valueForKeyPath:@"thumbnail.url"];
  UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageURL];
      NSString *subTitle = index < 1000 ? [NSString stringWithFormat:@"%d votes",index+1] : [NSString stringWithFormat:@"1.%dk votes",index/1000];
  if (cachedImage != nil) {
    [cell setTitle:@"VOTE" subTitle:subTitle image:cachedImage];
  }else{
    [cell setTitle:@"VOTE" subTitle:subTitle image:nil];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:imageURL] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [_gmGridView reloadObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade];
      });
    }];
  }
  return cell;
}

#pragma mark - 
#pragma mark GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
  CGRect modalRect = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width ,self.navigationController.view.frame.size.height);
  NSDictionary *data = [_currentData objectAtIndex:position];
  GPPhotoModalPanel *modalPanel = [[GPPhotoModalPanel alloc] initWithFrame:modalRect attributes:data];
	[self.navigationController.view addSubview:modalPanel];
  [modalPanel showFromPoint:[self.navigationController.view center]];
}

#pragma mark -
#pragma mark viewDidLoad

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor colorWithHex:0x0a3e4c]];
  [[UINavigationBar appearance] setTitleTextAttributes:@{
                              UITextAttributeTextColor: [UIColor colorWithHex:0x135a6e],
                        UITextAttributeTextShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0],
                       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                   UITextAttributeFont: [UIFont fontWithName:@"ProximaNova-Bold" size:18.0],
   }];
  [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
  self.navigationController.navigationBar.opaque = YES;
  self.title = @"#GROUPERGRAM";
  
  self.operationQueue = [[NSOperationQueue alloc] init];
  [self.operationQueue setMaxConcurrentOperationCount:2];
  
  _currentData = [[NSMutableArray alloc] init];
  
  NSInteger spacing = 8;
  GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44)];
  gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view.backgroundColor = [UIColor colorWithHex:0x135a6e];
  _gmGridView = gmGridView;
  _gmGridView.style = GMGridViewStyleSwap;
  _gmGridView.itemSpacing = spacing;
  _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
  _gmGridView.centerGrid = YES;
  _gmGridView.actionDelegate = self;
  _gmGridView.dataSource = self;
  _gmGridView.mainSuperView = self.navigationController.view;
  _gmGridView.backgroundColor = [UIColor colorWithHex:0x135a6e];
  _gmGridView.delegate = self;
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x-15, spacing, 121, 36)];
  label.text = @"#GROUPERGRAM";
  label.textColor = [UIColor colorWithHex:0x16aace];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:14];
  UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(spacing, spacing, 101, 36)];
  [logoImageView setImage:[UIImage imageNamed:@"grouper_logo.png"]];
  UIImageView *cameraImageView = [[UIImageView alloc] initWithFrame:CGRectMake(272, spacing, 38, 36)];
  [cameraImageView setImage:[UIImage imageNamed:@"camera_icon.png"]];
  
  self.activityView = [[UIActivityIndicatorView alloc]
                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  self.activityView.center = CGPointMake(self.view.center.x, self.view.center.y-self.activityView.frame.size.height);
  [self.activityView startAnimating];
  [self.view addSubview:logoImageView];
  [self.view addSubview:cameraImageView];
  [self.view addSubview:label];
  [self.view addSubview:gmGridView];
  [self.view addSubview:self.activityView];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageLoadSuccess:) name:kInstagramImagesDidLoadNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageLoadFailure:) name:kInstagramImagesDidFailNotification object:nil];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.instagram.com/v1/tags/groupergram/media/recent?client_id=444a4018593b48d48265f93328272f83"]];
  [self loadData:request];
}

@end
