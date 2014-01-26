//
//  ToDoItems.h
//  ToDoList
//
//  Created by Sandeep Shekhawat on 1/25/14.
//  Copyright (c) 2014 Bhagyashree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface ToDoItems : PFObject< PFSubclassing >
// Accessing this property is the same as objectForKey:@"title"
@property (retain) NSMutableArray* todoItems;

@end
