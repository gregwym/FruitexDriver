//
//  FDDeliveryPackingViewController.m
//  FruitexDriver
//
//  Created by Greg on 11/7/2013.
//  Copyright (c) 2013 Fruitex. All rights reserved.
//

#import "FDDeliveryPackingViewController.h"
#import "FDDeliveryDirectionViewController.h"
#import "FDDataManager.h"

#import <NSMoment.h>

@interface FDDeliveryPackingViewController ()

@end

@implementation FDDeliveryPackingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.title = @"Packing";
    [self packedOrderItemsDidChange];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View update

- (void)packedOrderItemsDidChange
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.packed == TRUE"];
    for (Order *order in self.delivery.orders) {
        NSOrderedSet *orderItems = order.orderItems;
        NSOrderedSet *packedOrderItems = [orderItems filteredOrderedSetUsingPredicate:predicate];
        NSLog(@"%@: %lu/%lu", order.user, (unsigned long)[packedOrderItems count], (unsigned long)[orderItems count]);
        if ([packedOrderItems count] < [orderItems count]) {
            self.nextStepButton.enabled = NO;
            return;
        }
    }
    self.nextStepButton.enabled = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.delivery.orders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [((Order* )[self.delivery.orders objectAtIndex:section]).orderItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    OrderItem *orderItem = [((Order* )[self.delivery.orders objectAtIndex:indexPath.section]).orderItems objectAtIndex:indexPath.row];
    cell.textLabel.text = orderItem.name;
    cell.detailTextLabel.text = orderItem.quantity.description;
    cell.accessoryType = [orderItem.packed boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Order *order = [self.delivery.orders objectAtIndex:section];
    return [NSString stringWithFormat:@"%@ @ %@", order.user, [[NSMoment momentWithDate:order.datePlaced] format:@"MMM dd yyyy, hh:mm"]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL wasPacked = [tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark;
    OrderItem *orderItem = [[self.delivery orderItemsForStore:[self.delivery.stores objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [orderItem updatePackedTo:!wasPacked];

    UITableViewCellAccessoryType accessoryType = [orderItem.packed boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = accessoryType;
    [self packedOrderItemsDidChange];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[FDDeliveryDirectionViewController class]]) {
        FDDeliveryDirectionViewController *vc = segue.destinationViewController;
        vc.orders = self.delivery.orders;
    }
}

@end
