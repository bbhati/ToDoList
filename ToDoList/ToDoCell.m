//
//  ToDoCell.m
//  ToDoList
//
//  Created by Bhagyashree Shekhawat on 1/25/14.
//  Copyright (c) 2014 Bhagyashree. All rights reserved.
//

#import "ToDoCell.h"

@implementation ToDoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
