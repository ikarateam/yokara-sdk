//
//  FruitBasket.h
//  yokara-sdk
//
//  Created by Tuấn Anh on 15/09/2022.
//

#ifndef FruitBasket_h
#define FruitBasket_h

#import <Foundation/Foundation.h>


@interface Fruit : NSObject

@property NSString* name;

@end

@interface Basket : NSObject

@property int capacity;
@property NSMutableArray* fruits;

- (void) add: (Fruit*) fruit;
- (id) initWithCapacity:  (int) c;
- (void) print;
@end

#endif /* FruitBasket_h */
