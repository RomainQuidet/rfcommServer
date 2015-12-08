//
//  DLog.h
//  GPS Demo
//
//  Created by Romain Quidet on 04/12/12.
//  Copyright (c) 2012 Aman Enterprises Inc. All rights reserved.
//

#ifndef DLog_h
#define DLog_h

#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define DLog(fmt, ...)
#endif

#endif
