// OVCUtilities.h
//
// Copyright (c) 2013-2016 Overcoat Team
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#define OVC_USING_XCODE_7 __has_feature(objc_generics)

#pragma mark - C++ Support

#ifdef __cplusplus
    #define OVC_EXTERN extern "C"
#else
    #define OVC_EXTERN extern
#endif

#pragma mark - Objective-C Nullability Support

#if __has_feature(nullability)
    #define OVC_NONNULL nonnull
    #define OVC_NULLABLE nullable
    #define OVC_NULL_RESETTABLE null_resettable
    #if OVC_USING_XCODE_7
        #define OVC__NONNULL _Nonnull
        #define OVC__NULLABLE _Nullable
        #define OVC__NULL_RESETTABLE _Null_resettable
    #else
        #define OVC__NONNULL __nonnull
        #define OVC__NULLABLE __nullable
        #define OVC__NULL_RESETTABLE __null_resettable
    #endif
#else
    #define OVC_NONNULL
    #define OVC__NONNULL
    #define OVC_NULLABLE
    #define OVC__NULLABLE
    #define OVC_NULL_RESETTABLE
    #define OVC__NULL_RESETTABLE
#endif

#if __has_feature(assume_nonnull)
    #ifndef NS_ASSUME_NONNULL_BEGIN
        #define NS_ASSUME_NONNULL_BEGIN _Pragma("clang assume_nonnull begin")
    #endif
    #ifndef NS_ASSUME_NONNULL_END
        #define NS_ASSUME_NONNULL_END _Pragma("clang assume_nonnull end")
    #endif
#else
    #define NS_ASSUME_NONNULL_BEGIN
    #define NS_ASSUME_NONNULL_END
#endif

#pragma mark - Objective-C Lightweight Generics Support

#if __has_feature(objc_generics)
    #define OVCGenerics(...) <__VA_ARGS__>
    #define OVCGenericType(TYPE, FALLBACK) TYPE
#else
    #define OVCGenerics(...)
    #define OVCGenericType(TYPE, FALLBACK) FALLBACK
#endif

#pragma mark - Designated Initailizer Support

#ifndef NS_DESIGNATED_INITIALIZER
    #if __has_attribute(objc_designated_initializer)
        #define NS_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
    #else
        #define NS_DESIGNATED_INITIALIZER
    #endif
#endif

#pragma mark - Deprecation

#define OVC_DEPRECATED(...) __attribute__((deprecated(__VA_ARGS__)))

#pragma mark - Helpers

#define OVC_IS_CLASS(obj) (class_isMetaClass(object_getClass((obj))) != 0)
