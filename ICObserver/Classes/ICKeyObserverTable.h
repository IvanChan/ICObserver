//
//  ICKeyObserverTable.h
//  ICObserver
//
//  Created by _ivanC on 01/04/2017.
//  Copyright © 2017 _ivanC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICKeyObserverTable : NSObject

- (void)addObserver:(id)observer forKey:(NSString *)key;
- (void)removeObserver:(id)observer forKey:(NSString *)key;

- (void)enumerateObserverForKey:(NSString *)key
         onMainThreadUsingBlock:(void (^)(id observer))block;

- (void)enumerateObserverForKey:(NSString *)key
    onMainThreadUsingBlockAsync:(void (^)(id observer))block;

@end
