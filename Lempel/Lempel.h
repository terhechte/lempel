//
//  Lempel.h
//  Lempel
//
//  Created by Benedikt Terhechte on 17/12/15.
//  Copyright © 2015 Benedikt Terhechte. All rights reserved.
//

#import "TargetConditionals.h"

#if TARGET_OS_IOS
    #import <UIKit/UIKit.h>
#else
    #import <Cocoa/Cocoa.h>
#endif

//! Project version number for Lempel.
FOUNDATION_EXPORT double LempelVersionNumber;

//! Project version string for Lempel.
FOUNDATION_EXPORT const unsigned char LempelVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Lempel/PublicHeader.h>


