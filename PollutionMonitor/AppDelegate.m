//
//  AppDelegate.m
//  PollutionMonitor
//
//  Created by Demian Turner on 13/12/2016.
//  Copyright © 2016 Seagull Systems. All rights reserved.
//

#import "AppDelegate.h"
#import "TestImage.h"
#import "PopoverViewController.h"
#import "NSString+Sha1.h"
#import "Reachability.h"

@interface AppDelegate()

//@property (weak, nonatomic) IBOutlet NSWindow *window;
//@property (strong, nonatomic) id popoverTransiencyMonitor;
@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation AppDelegate

#pragma mark - Application Lifecycle

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // update every 5 mins
    float intervalInSeconds = 60.0 * 5;
//    float intervalInSeconds = 10;
    [NSTimer scheduledTimerWithTimeInterval:intervalInSeconds
                                     target:self
                                   selector:@selector(timerFired:)
                                   userInfo:nil
                                    repeats:YES];
    
    // update reading when Mac wakes
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(timerFired:)
                                                               name:NSWorkspaceDidWakeNotification object:NULL];
    
    [self initializeStatusBarItem];
    
    NSString *lastUpdatedLocalTitle = @"Updating ...";
    NSString *lastUpdatedServerTitle = @"Updating ...";
    NSString *prefTitle = @"Preferencees";
    NSString *quitTitle = @"Quit";
				
    NSDictionary *one = @{lastUpdatedLocalTitle : [NSValue valueWithPointer:nil]};
    NSDictionary *two = @{lastUpdatedServerTitle : [NSValue valueWithPointer:nil]};
    NSDictionary *three = @{prefTitle : [NSValue valueWithPointer:nil]};
    NSDictionary *four = @{quitTitle : [NSValue valueWithPointer:@selector(terminate:)]};
    NSArray *menuItemsArray = @[one, two, three, four];
    
    self.statusItem.menu = [self initializeStatusBarMenu:menuItemsArray];
    
    // invoke first call, rest done by timer
    [self performSelector:@selector(timerFired:) withObject:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    self.statusItem = nil;
}

#pragma mark - Menu Bar


- (NSMenu *)initializeStatusBarMenu:(NSArray *)menuItemsArray
{
    NSMenu *menu = [[NSMenu alloc] init];
    
    for (NSDictionary *menuItems in menuItemsArray) {
        [menuItems enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSValue *val, BOOL *stop) {
            SEL action = nil;
            [val getValue:&action];
            [menu addItemWithTitle:key action:action keyEquivalent:@""];
        }];
    }
    
    return menu;
}

- (void)timerFired:(NSTimer *)timer
{
    if (! [self hasNetworkConnection]) {
        NSLog(@"no network");
        return;
    }
    
    NSString *feedUrl = @"https://feed.aqicn.org/xservices/refresh";
//    int cityCode = 1481; // Haerbin (main)
    int cityCode = 1282; // Taiping Hongwei Park, Haerbin, to right of bridge
//    int cityCode = 1437; // Shanghai
//    int cityCode = 1451; // Beijing
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    NSString *sha1Hash = [[uuidString sha1Hash] lowercaseString];
    NSString *dataUrl = [NSString stringWithFormat:@"%@:%d?%@", feedUrl, cityCode, sha1Hash];
    // format https://feed.aqicn.org/xservices/refresh:1284?b6928d68172703fe9468ea70e38a330439c3e1a2
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
      dataTaskWithURL:url
      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          NSString *measurement = jsonData[@"aqiv"];
          NSString *updateTime = jsonData[@"utime"];
          int reading = [measurement intValue];
          [self updateStatusItemWith:reading updatedAt:updateTime];
          NSLog(@"%@", jsonData);
      }];
    [downloadTask resume];
}

- (void)updateStatusItemWith:(int)reading updatedAt:(NSString *)updatedString
{
    NSImage *image = [TestImage imageOfMyImage:reading];
    [self.statusItem setImage:image];
    
    // local update time
    NSMenuItem *menuItemLocal = [self.statusItem.menu itemAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *lastUpdatedLocal = [@"Local Last Updated: " stringByAppendingString:stringDate];
    [menuItemLocal setTitle:lastUpdatedLocal];
    
    // server update time
    NSMenuItem *menuItemServer = [self.statusItem.menu itemAtIndex:1];
    NSString *lastUpdatedServer = [@"Server Last Updated: " stringByAppendingString:updatedString];
    [menuItemServer setTitle:lastUpdatedServer];
    
    NSLog(@"timer fired");
    NSLog(@"Server Last Updated %@", updatedString);
    NSLog(@"reading %d", reading);
}

- (void)initializeStatusBarItem
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.highlightMode = YES;
    NSStatusBarButton *button = self.statusItem.button;
    button.action = @selector(buttonClicked2:);
}

#pragma mark - Actions

- (IBAction)buttonClicked2:(NSStatusBarButton *)sender
{
    NSLog(@"bar"); // never called because menu implemented for statusItem
}

#pragma mark - Helpers

- (BOOL)hasNetworkConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


//- (IBAction)buttonClicked:(NSStatusBarButton *)sender
//{
//    // Create view controller
//    PopoverViewController *viewController = [[PopoverViewController alloc] init];
//
//    // Create popover
//    NSPopover *entryPopover = [[NSPopover alloc] init];
//    [entryPopover setContentSize:NSMakeSize(200.0, 200.0)];
//    [entryPopover setBehavior:NSPopoverBehaviorTransient];
//    [entryPopover setAnimates:YES];
//    [entryPopover setContentViewController:viewController];
//
//    // Convert point to main window coordinates
////    NSRect entryRect = [sender convertRect:sender.bounds
////                                    toView:self.statusItem.view];
//
//    // Show popover
//    [entryPopover showRelativeToRect:sender.bounds
//                              ofView:self.statusItem.view
//                       preferredEdge:NSMinYEdge];
//
//    // handle close click
//    if (self.popoverTransiencyMonitor == nil) {
//        self.popoverTransiencyMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:(NSEventMaskLeftMouseDown | NSEventMaskRightMouseDown | NSEventMaskKeyUp) handler:^(NSEvent* event) {
//                [NSEvent removeMonitor:self.popoverTransiencyMonitor];
//                self.popoverTransiencyMonitor = nil;
//                [entryPopover close];
//        }];
//    }
//}

@end
