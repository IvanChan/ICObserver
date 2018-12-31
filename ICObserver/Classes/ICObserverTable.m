//
//  ICObserverTable.m
//  ICObserver
//
//  Created by _ivanC on 30/11/2016.
//  Copyright © 2016 _ivanC. All rights reserved.
//

#import "ICObserverTable.h"

@interface ICObserverTable ()

@property (nonatomic, strong) NSHashTable *observerList;

@property (nonatomic, strong) NSHashTable *addObserverList;
@property (nonatomic, strong) NSHashTable *removeObserverList;

@property (atomic, assign) BOOL isEnumerating;

@end

@implementation ICObserverTable

#pragma mark - Getters
- (NSHashTable *)observerList
{
    if (_observerList == nil)
    {
        _observerList = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:2];
    }
    return _observerList;
}

- (NSHashTable *)addObserverList
{
    if (_addObserverList == nil)
    {
        _addObserverList = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:2];
    }
    return _addObserverList;
}

- (NSHashTable *)removeObserverList
{
    if (_removeObserverList == nil)
    {
        _removeObserverList = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:2];
    }
    return _removeObserverList;
}

#pragma mark - Observers
- (void)addObserver:(id)observer
{
    if (observer == nil)
    {
        return;
    }
    
    @synchronized (self)
    {
        if (observer)
        {
            if (self.isEnumerating)
            {
                [self.addObserverList addObject:observer];
                
            }
            else
            {
                [self.observerList addObject:observer];
            }
        }
    }
}


- (void)removeObserver:(id)observer
{
    if (observer == nil)
    {
        return;
    }
    
    @synchronized (self)
    {
        if (self.isEnumerating)
        {
            [self.removeObserverList addObject:observer];
        }
        else
        {
            [self.observerList removeObject:observer];
        }
    }
}

- (void)enumerateObserverUsingBlock:(void (^)(id observer))block
{
    @synchronized (self)
    {
        self.isEnumerating = YES;
        
        for (id target in self.observerList)
        {
            block(target);
        }
        
        // merge data
        [self.observerList unionHashTable:self.addObserverList];
        [self.observerList minusHashTable:self.removeObserverList];
        
        [self.addObserverList removeAllObjects];
        [self.removeObserverList removeAllObjects];
        
        self.isEnumerating = NO;
        
    }
}

- (void)enumerateObserverOnMainThreadUsingBlock:(void (^)(id observer))block
{
    if (block == nil)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        [self enumerateObserverUsingBlock:block];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self enumerateObserverUsingBlock:block];
        });
    }
}

- (void)enumerateObserverOnMainThreadAsyncUsingBlock:(void (^)(id observer))block
{
    if (block == nil)
    {
        return;
    }
    
    if ([NSThread isMainThread])
    {
        [self enumerateObserverUsingBlock:block];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self enumerateObserverUsingBlock:block];
        });
    }
}

@end
