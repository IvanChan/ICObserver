//
//  ICObserverTable.h
//  ICObserver
//
//  Created by _ivanC on 30/11/2016.
//  Copyright © 2016 _ivanC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICObserverTable : NSObject

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

- (void)enumerateObserverOnMainThreadUsingBlock:(void (^)(id observer))block;
- (void)enumerateObserverOnMainThreadUsingBlockAsync:(void (^)(id observer))block;

@end
