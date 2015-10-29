// Overcoat.h
//
// Copyright (c) 2013 Guillermo Gonzalez
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

#import <Overcoat/OVCUtilities.h>
#import <Overcoat/OVCResponse.h>
#import <Overcoat/OVCURLMatcher.h>
#import <Overcoat/OVCModelResponseSerializer.h>
#import <Overcoat/NSError+OVCResponse.h>
#import <Overcoat/NSDictionary+Overcoat.h>
#import <Overcoat/OVCHTTPManager.h>

#if OVERCOAT_SUPPORT_URL_CONNECTION
#import <Overcoat/OVCHTTPRequestOperationManager.h>
#endif
#if OVERCOAT_SUPPORT_URL_SESSION
#import <Overcoat/OVCHTTPSessionManager.h>
#endif

// Shortcuts for subspec headers
#if OVERCOAT_SUPPORT_COREDATA
#import <Overcoat/CoreData+Overcoat.h>
#endif
#if OVERCOAT_SUPPORT_SOCIAL
#import <Overcoat/OVCSocialRequestSerializer.h>
#endif
#if OVERCOAT_SUPPORT_PROMISE_KIT
#import <Overcoat/PromiseKit+Overcoat.h>
#endif
#if OVERCOAT_SUPPORT_REACTIVE_COCOA
#import <Overcoat/ReactiveCocoa+Overcoat.h>
#endif
