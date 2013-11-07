//
//  Order.h
//  FruitexDriver
//
//  Created by Greg on 11/7/2013.
//  Copyright (c) 2013 Fruitex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Delivery, OrderItem;

@interface Order : NSManagedObject

@property (nonatomic, retain) Delivery *delivery;
@property (nonatomic, retain) NSOrderedSet *orderItems;
@end

@interface Order (CoreDataGeneratedAccessors)

- (void)insertObject:(OrderItem *)value inOrderItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOrderItemsAtIndex:(NSUInteger)idx;
- (void)insertOrderItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOrderItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOrderItemsAtIndex:(NSUInteger)idx withObject:(OrderItem *)value;
- (void)replaceOrderItemsAtIndexes:(NSIndexSet *)indexes withOrderItems:(NSArray *)values;
- (void)addOrderItemsObject:(OrderItem *)value;
- (void)removeOrderItemsObject:(OrderItem *)value;
- (void)addOrderItems:(NSOrderedSet *)values;
- (void)removeOrderItems:(NSOrderedSet *)values;
@end
