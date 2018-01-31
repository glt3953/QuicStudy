//
//  NXQuicNetService.h
//  QuicStudy
//
//  Created by guoliting on 2018/1/31.
//  Copyright © 2018年 NingXia. All rights reserved.
//

#import <Foundation/Foundation.h>

// Type of HTTP cache; public interface to private implementation defined in
// URLRequestContextConfig class.
typedef NS_ENUM(NSInteger, CRNHttpCacheType) {
    // Disabled HTTP cache.  Some data may still be temporarily stored in memory.
    CRNHttpCacheTypeDisabled,
    // Enable on-disk HTTP cache, including HTTP data.
    CRNHttpCacheTypeDisk,
    // Enable in-memory cache, including HTTP data.
    CRNHttpCacheTypeMemory,
};

@interface NXQuicNetService : NSObject

// Sets whether QUIC should be supported by CronetEngine. This method only has
// any effect before |start| is called.
+ (void)setQuicEnabled:(BOOL)quicEnabled;

@end
