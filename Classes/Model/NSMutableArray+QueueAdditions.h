//
//  NSMutableArray+QueueAdditions.h
//  Karaoke
//
//  Created by Rain Nguyen on 12/4/20.
//  Copyright © 2020 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (QueueAdditions)

- (id) pop;
- (id) queueHead;
- (id) dequeue;
- (void) enqueue:(id)obj;

@end
