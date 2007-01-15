/*
 *  SELibraryWindow.m
 *  Spark Editor
 *
 *  Created by Black Moon Team.
 *  Copyright (c) 2004 - 2006, Shadow Lab. All rights reserved.
 */

#import "SELibraryWindow.h"

#import "Spark.h"
#import "SETableView.h"
#import "SELibrarySource.h"
#import "SELibraryDocument.h"

#import "SEApplicationView.h"
#import "SETriggersController.h"

#import "SEServerConnection.h"

#import <SparkKit/SparkList.h>
#import <SparkKit/SparkPlugIn.h>
#import <SparkKit/SparkLibrary.h>

@implementation SELibraryWindow

- (id)init {
  if (self = [super initWithWindowNibName:@"SELibraryWindow"]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeStatus:)
                                                 name:SEServerStatusDidChangeNotification
                                               object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super dealloc];
}

- (SparkLibrary *)library {
  return [[self document] library];
}

- (void)windowDidLoad {
  [[self window] center];
  [[self window] setFrameAutosaveName:@"SparkMainWindow"];
  [[self window] setBackgroundColor:[NSColor colorWithCalibratedWhite:.773 alpha:1]];
  [[self window] display];
}

- (void)setDocument:(NSDocument *)aDocument {
  if ([super document]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SEApplicationDidChangeNotification
                                                  object:[self document]];
  }
  [super setDocument:aDocument];
  if (aDocument) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidChange:)
                                                 name:SEApplicationDidChangeNotification
                                               object:[self document]];
  }
}

- (void)awakeFromNib {
  /* Configure application field */
  [appField setTarget:appDrawer];
  [appField setAction:@selector(toggle:)];
  
  /* Configure list double action */
  [libraryTable setTarget:self];
  [libraryTable setDoubleAction:@selector(libraryDoubleAction:)];
  
  /* Update status */
  [self performSelector:@selector(didChangeStatus:) withObject:nil];
  
  /* Configure New Plugin Menu */
  [ibMenu setMenu:[NSApp pluginsMenu] forSegment:0];
  [[ibMenu cell] setToolTip:NSLocalizedString(@"CREATE_TRIGGER_TOOLTIP", @"Segment Menu ToolTips") forSegment:0];
}

- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem {
  if ([menuItem action] == @selector(copy:) || [menuItem action] == @selector(paste:)) {
    NSResponder *first = [[self window] firstResponder];
    return libraryTable == first || [triggers tableView] == first;
  }
  return YES;
}

- (IBAction)copy:(id)sender {
  ShadowTrace();
}

- (IBAction)paste:(id)sender {
  ShadowTrace();
}

- (IBAction)libraryDoubleAction:(id)sender {
  int idx = [libraryTable selectedRow];
  if (idx > 0) {
    SparkList *object = [listSource objectAtIndex:idx];
    if ([object uid] > kSparkLibraryReserved) {
      [libraryTable editColumn:0 row:idx withEvent:nil select:YES];
    } else {
      SparkPlugIn *plugin = [listSource pluginForList:object];
      if (plugin) {
        // Shared manager -> create entry:type
        DLog(@"Create entry: %@", plugin);
        //[[self manager] createEntry:plugin modalForWindow:[self window]];
      }
    }
  }
}

- (IBAction)newTriggerFromMenu:(id)sender {
  if ([sender respondsToSelector:@selector(representedObject)]) {
    id object = [sender representedObject];
    if ([object isKindOfClass:[SparkPlugIn class]])
      DLog(@"Create entry: %@", [sender representedObject]);
      //[[self manager] createEntry:[sender representedObject] modalForWindow:[self window]];
  }
}
/* Notification handler */
- (void)applicationDidChange:(NSNotification *)aNotification {
  [appField setSparkApplication:[[aNotification object] application]];
}

/* Selected list did change */
- (void)source:(SELibrarySource *)aSource didChangeSelection:(SparkList *)aList {
  [triggers setList:aList];
}

/* Enable menu item */
- (IBAction)newList:(id)sender {
  [listSource newList:sender];
}

- (IBAction)toggleDaemon:(id)sender {
  [[NSApp delegate] toggleServer:sender];
}

- (void)didChangeStatus:(NSNotification *)aNotification {
  NSString *str = @"";
  NSImage *up = nil, *down = nil;
  SparkDaemonStatus status = [NSApp serverStatus];
  switch (status) {
    case kSparkDaemonStarted:
      str = NSLocalizedString(@"Spark is active", @"Spark Daemon status string");
      up = [NSImage imageNamed:@"stop"];
      down = [NSColor currentControlTint] == NSBlueControlTint ? [NSImage imageNamed:@"stop_bdown"] : [NSImage imageNamed:@"stop_gdown"];
      break;
    case kSparkDaemonStopped:
      str = NSLocalizedString(@"Spark is disabled", @"Spark Daemon status string");
      up = [NSImage imageNamed:@"start"];
      down = [NSColor currentControlTint] == NSBlueControlTint ? [NSImage imageNamed:@"start_bdown"] : [NSImage imageNamed:@"start_gdown"];
      break;
    case kSparkDaemonError:
      str = NSLocalizedString(@"Unexpected error occured", @"Spark Daemon status string");
      break;
  }
  [ibStatus setStringValue:str];
  if (up && down) {
    [ibDaemon setImage:up];
    [ibDaemon setAlternateImage:down];
  }
}

@end
