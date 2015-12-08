//
//  ViewController.m
//  rfcommServer
//
//  Created by Romain Quidet on 08/12/2015.
//  Copyright © 2015 xdappfactory. All rights reserved.
//

#import "ViewController.h"
#import "DLog.h"
#import "privateHelper.h"
#import <IOBluetooth/objc/IOBluetoothRFCOMMChannel.h>
#import <IOBluetooth/objc/IOBluetoothSDPServiceRecord.h>

@interface ViewController () <IOBluetoothRFCOMMChannelDelegate>

@property (nonatomic, assign) BluetoothRFCOMMChannelID rfcommChannelID;
@property (nonatomic, assign) BluetoothSDPServiceRecordHandle SDPServiceRecordHandle;
@property (nonatomic, strong) IOBluetoothUserNotification *incomingRFCOMMChannelNotification;

@end

@implementation ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    DLog(@"");
    self.receiveTextView.editable = NO;
    
    // Turn on Discoverability
    if (!IOBluetoothPreferenceGetDiscoverableState()) {
        IOBluetoothPreferenceSetDiscoverableState(1);
    }
    
    // start our RFCOMM server
    BOOL res = [self publishService];
    if (!res) {
        self.receiveTextView.string = @"Error, can't publish RFCOMM server";
    }
    else {
        self.receiveTextView.string = @"RFCOMM server ready\r\n";
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - Internals

- (BOOL)publishService {
    DLog(@"Enter");
    
    // Load SDP config dictionary
    NSString *dictionaryPath = [[NSBundle mainBundle] pathForResource:@"SerialPortDictionary" ofType:@"plist"];
    NSMutableDictionary *sdpEntries = [NSMutableDictionary dictionaryWithContentsOfFile:dictionaryPath];
    
    // Publish SDP service
    IOBluetoothSDPServiceRecord *serviceRecord = [IOBluetoothSDPServiceRecord publishedServiceRecordWithDictionary:sdpEntries];
    
    IOReturn res = [serviceRecord getRFCOMMChannelID:&_rfcommChannelID];
    if(res != kIOReturnSuccess)
    {
        DLog(@"getRFCOMMChannelID failed: %@", @(res));
        return NO;
    }
    res = [serviceRecord getServiceRecordHandle:&_SDPServiceRecordHandle];
    if(res != kIOReturnSuccess)
    {
        DLog(@"getServiceRecordHandle failed: %@", @(res));
        return NO;
    }
    
    DLog(@"Service Name is %@", [serviceRecord getServiceName]);
    
    // Register a notification so we get notified when an incoming RFCOMM channel is opened
    // to the channel assigned to our chat service.
    self.incomingRFCOMMChannelNotification = [IOBluetoothRFCOMMChannel registerForChannelOpenNotifications:self
                                                                                                  selector:@selector(newRFCOMMChannelOpened:channel:)];
    return YES;
}

#pragma mark - UI interface

- (IBAction)sendButtonTapped:(id)sender {
    DLog(@"");
}

#pragma mark - RFCOMM open notification

- (void)newRFCOMMChannelOpened:(IOBluetoothUserNotification *)inNotification channel:(IOBluetoothRFCOMMChannel *)newChannel {
    DLog(@"");
    if ([inNotification isEqual:self.incomingRFCOMMChannelNotification]) {
        DLog(@"Good, our RFCOMM channel is in use");
        newChannel.delegate = self;
    }
    else {
        DLog(@"Mhh doesn't seems to be our channel id");
    }
}

#pragma mark - RFCOMM Channel delegate

- (void)rfcommChannelData:(IOBluetoothRFCOMMChannel*)rfcommChannel data:(void *)dataPointer length:(size_t)dataLength {
    DLog(@"got %@ bytes", @(dataLength));
}

- (void)rfcommChannelOpenComplete:(IOBluetoothRFCOMMChannel*)rfcommChannel status:(IOReturn)error {
    DLog(@"open %@", error == kIOReturnSuccess ? @"OK" : @"Error");
}

- (void)rfcommChannelClosed:(IOBluetoothRFCOMMChannel*)rfcommChannel {
    DLog(@"");
}

- (void)rfcommChannelControlSignalsChanged:(IOBluetoothRFCOMMChannel*)rfcommChannel {
    DLog(@"");
}

- (void)rfcommChannelFlowControlChanged:(IOBluetoothRFCOMMChannel*)rfcommChannel {
    DLog(@"");
}

- (void)rfcommChannelWriteComplete:(IOBluetoothRFCOMMChannel*)rfcommChannel refcon:(void*)refcon status:(IOReturn)error {
    DLog(@"write %@", error == kIOReturnSuccess ? @"OK" : @"Error");
}

- (void)rfcommChannelQueueSpaceAvailable:(IOBluetoothRFCOMMChannel*)rfcommChannel {
    DLog(@"");
}

@end
