//
//  AppDelegate.m
//  Groupergram
//
//  Created by Kurry L Tran on 5/25/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SDURLCache.h"
#import "SDImageCache.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024*1024   // 10MB mem cache
                                                       diskCapacity:1024*1024*1024*5 // 50MB disk cache
                                                           diskPath:[SDURLCache defaultCachePath]];
  [NSURLCache setSharedURLCache:urlCache];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  ViewController *masterViewController = [[ViewController alloc] init];
  self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
