//
//  ICKeyObserverTable.m
//  ICObserver
//
//  Created by _ivanC on 01/04/2017.
//  Copyright © 2017 _ivanC. All rights reserved.
//

#import "ICKeyObserverTable.h"
#import "ICObserverTable.h"

@interface ICKeyObserverTable ()

@property (nonatomic, strong) NSMutableDictionary *observerHash;

@end

@implementation ICKeyObserverTable

#pragma mark - Getters
- (NSMutableDictionary *)observerHash
{
    if (_observerHash == nil)
    {
        _observerHash = [[NSMutableDictionary alloc] initWithCapacity:7];
    }
    return _observerHash;
}

- (ICObserverTable *)generateObserverList:(NSString *)key
{
    ICObserverTable *table = [ICObserverTable new];
    self.observerHash[key] = table;
    
    return table;
}

#pragma mark - Public
- (void)addObserver:(id)observer forKey:(NSString *)key
{
    if (observer == nil || key.length <= 0)
    {
        return;
    }
    
    @synchronized (self)
    {
        ICObserverTable *table = self.observerHash[key];
        if (table == nil)
        {
            table = [self generateObserverList:key];
        }
        
        [table addObserver:observer];
    }
}

- (void)removeObserver:(id)observer forKey:(NSString *)key
{
    if (observer == nil || key.length <= 0)
    {
        return;
    }
    
    @synchronized (self)
    {
        ICObserverTable *table = self.observerHash[key];
        if (table == nil)
        {
            return;
        }
        
        [table removeObserver:observer];
    }
}

- (void)enumerateObserverForKey:(NSString *)key
         onMainThreadUsingBlock:(void (^)(id observer))block
{
    if (key.length <= 0 || block == nil)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        [self _enumerateObserverForKey:key onMainThreadUsingBlock:block];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
        
            [self _enumerateObserverForKey:key onMainThreadUsingBlock:block];
        });
    }
}

- (void)enumerateObserverForKey:(NSString *)key
    onMainThreadUsingBlockAsync:(void (^)(id observer))block
{
    if (key.length <= 0 || block == nil)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        [self _enumerateObserverForKey:key onMainThreadUsingBlock:block];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self _enumerateObserverForKey:key onMainThreadUsingBlock:block];
        });
    }
}

- (void)_enumerateObserverForKey:(NSString *)key
         onMainThreadUsingBlock:(void (^)(id observer))block
{
    @synchronized (self)
    {
        ICObserverTable *table = self.observerHash[key];
        [table enumerateObserverOnMainThreadUsingBlock:^(id observer) {
            block(observer);
        }];
    }
}

@end
