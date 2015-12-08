//
//  ViewController.h
//  rfcommServer
//
//  Created by Romain Quidet on 08/12/2015.
//  Copyright © 2015 xdappfactory. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (nonatomic, weak) IBOutlet NSButton *sendButton;
@property (nonatomic, weak) IBOutlet NSTextField *sendTextField;
@property (nonatomic, strong) IBOutlet NSTextView *receiveTextView;


@end

