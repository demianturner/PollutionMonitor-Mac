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

@interface AppDelegate()

//@property (weak, nonatomic) IBOutlet NSWindow *window;
//@property (strong, nonatomic) id popoverTransiencyMonitor;
@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // update hourly
    float oneHourInSeconds = 60.0 * 60.0;
    [NSTimer scheduledTimerWithTimeInterval:oneHourInSeconds
                                     target:self
                                   selector:@selector(timerFired:)
                                   userInfo:nil
                                    repeats:YES];
    
    // udpate reading when Mac wakes
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(timerFired:)
                                                               name: NSWorkspaceDidWakeNotification object: NULL];
    
    [self initializeStatusBarItem];
    
    NSString *lastUpdatedTitle = @"Updating ...";
    NSString *prefTitle = @"Preferencees";
    NSString *quitTitle = @"Quit";
				
    NSDictionary *one = @{lastUpdatedTitle : [NSValue valueWithPointer:nil]};
    NSDictionary *two = @{prefTitle : [NSValue valueWithPointer:nil]};
    NSDictionary *three = @{quitTitle : [NSValue valueWithPointer:@selector(terminate:)]};
    NSArray *menuItemsArray = @[one, two, three];
    
    self.statusItem.menu = [self initializeStatusBarMenu:menuItemsArray];
    
    // invoke first call, rest done by timer
    [self performSelector:@selector(timerFired:) withObject:nil];
}

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
    NSString *feedUrl = @"https://feed.aqicn.org/xservices/refresh";
    int cityCode = 1481; // Haerbin (main)
//    int cityCode = 1282; // Taiping Hongwei Park, Haerbin, to right of bridge
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
    NSMenuItem *menuItem = [self.statusItem.menu itemAtIndex:0];
    NSString *lastUpdated = [@"Server Last Updated: " stringByAppendingString:updatedString];
    [menuItem setTitle:lastUpdated];
    
    NSLog(@"timer fired");
    NSLog(@"Server Last Updated %@", updatedString);
    NSLog(@"reading %d", reading);
}

- (void)initializeStatusBarItem {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.highlightMode = YES;
    NSStatusBarButton *button = self.statusItem.button;
    button.action = @selector(buttonClicked2:);
}

- (IBAction)buttonClicked2:(NSStatusBarButton *)sender
{
    NSLog(@"bar"); // never called because menu implemented for statusItem
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    self.statusItem = nil;
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
