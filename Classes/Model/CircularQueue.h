//
//  CircularQueue.h
//  AudioMixEffect
//
//  Created by Rain Nguyen on 12/28/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface CircularQueue : NSObject <NSFastEnumeration>
@property (nonatomic, assign, readonly) NSUInteger capacity;
@property (nonatomic, assign, readonly) NSUInteger count;
- (id)initWithCapacity:(NSUInteger)capacity;
- (void)enqObject:(id)obj; // Enqueue
- (id)deqObject;           // Dequeue
- (id)objectAtIndex:(NSUInteger)index;
- (void)removeAllObjects;

@end
