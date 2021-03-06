// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.  All rights reserved.
// https://developers.google.com/protocol-buffers/
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//     * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "GPBExtensionRegistry.h"

#import "GPBBootstrap.h"
#import "GPBDescriptor.h"

@implementation GPBExtensionRegistry {
  // TODO(dmaclach): Reimplement with CFDictionaries that don't use
  // objects as keys.
  NSMutableDictionary *mutableClassMap_;
}

- (instancetype)init {
  if ((self = [super init])) {
    mutableClassMap_ = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)dealloc {
  [mutableClassMap_ release];
  [super dealloc];
}

- (instancetype)copyWithZone:(NSZone *)zone {
  GPBExtensionRegistry *result = [[[self class] allocWithZone:zone] init];
  if (result && mutableClassMap_.count) {
    [result->mutableClassMap_ addEntriesFromDictionary:mutableClassMap_];
  }
  return result;
}

- (NSMutableDictionary *)extensionMapForContainingMessageClass:
        (Class)containingMessageClass {
  NSMutableDictionary *extensionMap =
      [mutableClassMap_ objectForKey:containingMessageClass];
  if (extensionMap == nil) {
    extensionMap = [NSMutableDictionary dictionary];
    [mutableClassMap_ setObject:extensionMap
                         forKey:(id<NSCopying>)containingMessageClass];
  }
  return extensionMap;
}

- (void)addExtension:(GPBExtensionDescriptor *)extension {
  if (extension == nil) {
    return;
  }

  Class containingMessageClass = extension.containingMessageClass;
  NSMutableDictionary *extensionMap =
      [self extensionMapForContainingMessageClass:containingMessageClass];
  [extensionMap setObject:extension forKey:@(extension.fieldNumber)];
}

- (GPBExtensionDescriptor *)extensionForDescriptor:(GPBDescriptor *)descriptor
                                       fieldNumber:(NSInteger)fieldNumber {
  Class messageClass = descriptor.messageClass;
  NSDictionary *extensionMap =
      [mutableClassMap_ objectForKey:messageClass];
  return [extensionMap objectForKey:@(fieldNumber)];
}

- (void)addExtensions:(GPBExtensionRegistry *)registry {
  if (registry == nil) {
    // In the case where there are no extensions just ignore.
    return;
  }
  NSMutableDictionary *otherClassMap = registry->mutableClassMap_;
  for (Class containingMessageClass in otherClassMap) {
    NSMutableDictionary *extensionMap =
        [self extensionMapForContainingMessageClass:containingMessageClass];
    NSMutableDictionary *otherExtensionMap =
        [registry extensionMapForContainingMessageClass:containingMessageClass];
    [extensionMap addEntriesFromDictionary:otherExtensionMap];
  }
}

@end
