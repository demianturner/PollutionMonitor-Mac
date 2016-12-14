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

@interface AppDelegate()

@property (weak, nonatomic) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
//@property (strong, nonatomic) NSString *imageName;
//@property (strong, nonatomic) NSPopover *popover;
@property (strong, nonatomic) id popoverTransiencyMonitor;

@end

@implementation AppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {

//    _imageName = @"white";
//    self.statusItem = [self initializeStatusBarItem];
//    
//    _statusItem.image = [NSImage imageNamed:@"exclamation@2x.png"];
//    NSString *portTitle = @"foo";
//    NSString *quitTitle = @"Quit";
//    _statusItem.menu = [self initializeStatusBarMenu:@{
//                                                       portTitle: [NSValue valueWithPointer:nil],
//                                                       quitTitle: [NSValue valueWithPointer:@selector(terminate:)]
//                                                       }];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
//    self.statusItem.alternateImage = [NSImage imageNamed:@"white_alt@2x.png"];
    self.statusItem.highlightMode = YES;
    
    NSStatusBarButton *button = self.statusItem.button;
//    button.image = [NSImage imageNamed:@"purple@2x.png"];
    button.image = [TestImage imageOfMyImage:23];
    button.action = @selector(buttonClicked2:);
    NSString *portTitle = @"Preferencees";
    NSString *quitTitle = @"Quit";
    self.statusItem.menu = [self initializeStatusBarMenu:@{
       portTitle: [NSValue valueWithPointer:nil],
       quitTitle: [NSValue valueWithPointer:@selector(terminate:)]
       }];
}

- (IBAction)buttonClicked2:(NSStatusBarButton *)sender
{
    NSLog(@"bar");
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

-(void)applicationWillTerminate:(NSNotification *)aNotification {
    
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    self.statusItem = nil;
}


- (NSStatusItem *)initializeStatusBarItem {
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusItem.alternateImage = [NSImage imageNamed:@"white_alt@2x.png"];
    statusItem.highlightMode = YES;
    return statusItem;
}

-(NSMenu *)initializeStatusBarMenu:(NSDictionary*)menuDictionary {
    NSMenu *menu = [[NSMenu alloc] init];
    
    [menuDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSValue *val, BOOL *stop) {
        SEL action = nil;
        [val getValue:&action];
        [menu addItemWithTitle:key action:action keyEquivalent:@""];
    }];
    
    return menu;
}

@end
