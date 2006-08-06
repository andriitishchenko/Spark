/*
 *  HKHotKeyRegister.h
 *  HotKeyToolKit
 *
 *  Created by Grayfox.
 *  Copyright 2004-2006 Shadow Lab. All rights reserved.
 */
/*!
    @header HKHotKeyRegister
*/
#import <HotKeyToolKit/HKBase.h>

/*!
    @function   HKRegisterHotKey
    @abstract   Register a Global EventHotKey.
    @param      keycode The HotKey keycode
    @param      modifier The HotKey modifier.
    @param      hotKeyId An uniq HotKeyID passed as parameter in callback function.
    @result     Returns a EventHotKeyRef that you must keep to unregister the HotKey.
*/
HK_PRIVATE
EventHotKeyRef HKRegisterHotKey(UInt16 keycode, UInt32 modifier, EventHotKeyID hotKeyId);
/*!
    @function   UnregisterHotKey
    @abstract   Unregister an Global EventHotKey.
    @param      ref The event HotKey Reference obtains during registration.
    @result     Return YES if the key is succesfully unregistred.
*/
HK_PRIVATE
BOOL HKUnregisterHotKey(EventHotKeyRef ref);
