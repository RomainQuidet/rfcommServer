//
//  privateHelper.h
//  rfcommServer
//
//  Created by Romain Quidet on 08/12/2015.
//  Copyright © 2015 xdappfactory. All rights reserved.
//

#ifndef privateHelper_h
#define privateHelper_h

// Declaration of private API
void IOBluetoothPreferenceSetDiscoverableState(int discoverable);
int IOBluetoothPreferenceGetDiscoverableState();

void IOBluetoothPreferenceSetControllerPowerState(int powered);
int IOBluetoothPreferenceGetControllerPowerState();


#endif /* privateHelper_h */
