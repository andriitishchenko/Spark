/*
 *  HKBase.h
 *  HotKeyToolKit
 *
 *  Created by Shadow Team.
 *  Copyright (c) 2004 - 2008 Shadow Lab. All rights reserved.
 */

#pragma mark Base Macros

#if !defined(__HKBASE_H)
#define __HKBASE_H 1

#include <CoreServices/CoreServices.h>

#if defined(__cplusplus)
#if defined (__GNUC__) && (__GNUC__ >= 4)
#define HK_EXPORT extern "C" __attribute__((visibility("default")))
#else
#define HK_EXPORT extern "C"
#endif
#define __inline__ inline
#endif

#if !defined(HK_EXPORT)
#if defined (__GNUC__) && (__GNUC__ >= 4)
#define HK_EXPORT extern __attribute__((visibility("default")))
#else
#define HK_EXPORT extern
#endif
#endif

#if !defined(HK_CLASS_EXPORT)
#if __LP64__
#define HK_CLASS_EXPORT __attribute__((visibility("default")))
#else
#define HK_CLASS_EXPORT 
#endif
#endif

#if !defined(HK_INLINE)
#if defined (__GNUC__) && (__GNUC__ >= 4) && !defined(DEBUG)
#define HK_INLINE static __inline__ __attribute__((always_inline))
#else
#define HK_INLINE static __inline__
#endif
#endif

#if !defined(HK_PRIVATE)
#if defined(DEBUG)
#define HK_PRIVATE HK_EXPORT
#elif defined (__GNUC__) && (__GNUC__ >= 4)
#define HK_PRIVATE __private_extern__ __attribute__((visibility("hidden")))
#else
#define HK_PRIVATE __private_extern__
#endif /* DEBUG */
#endif

typedef uint32_t HKModifier;
typedef CGKeyCode HKKeycode;

#endif /* __HKBASE_H */