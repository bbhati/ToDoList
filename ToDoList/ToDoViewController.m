//
//  ToDoViewController.m
//  ToDoList
//
//  Created by Bhagyashree Shekhawat on 1/25/14.
//  Copyright (c) 2014 Bhagyashree. All rights reserved.
//

#import "ToDoViewController.h"
#import "ToDoCell.h"
#import "UIView+UIViewWithSuperviewType.h"
#import "ToDoItems.h"

@interface ToDoViewController ()

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define FONT_SIZE 14.0

@property(nonatomic, strong) NSMutableArray* toDoItems;

- (void)addNewToDo;
- (CGSize)calcSize:(NSString *)text;
- (CGSize)text:(NSString *)text constrainedToSize:(CGSize)size;
- (void)hideKeyboard;

@end

@implementation ToDoViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"InitWithStyle");
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder{
        NSLog(@"initWithCoder");
    self = [super initWithCoder:aDecoder];
    if(self){
        self.toDoItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 274, 44)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addNewToDo)];

}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear");
    self.toDoItems = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"savedToDo"];
    PFObject *testObject = [PFObject objectWithClassName:@"ToDoItems"];
    testObject[@"todoItems"] = self.toDoItems;
    [testObject saveInBackground];

}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setObject:self.toDoItems forKey:@"savedToDo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TextView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    NSString* toSave = [textView.text stringByReplacingCharactersInRange:range withString:text];
    ToDoCell* cellContainingFirstResponder = (ToDoCell*)[textView superViewWithClass:[UITableViewCell class]];
    NSIndexPath *currentRowIndexPath = [self.tableView indexPathForCell:cellContainingFirstResponder];
    
    NSInteger arrayIndex = currentRowIndexPath.row;
    NSLog(@"arrayIndex: %d", arrayIndex);
    self.toDoItems[arrayIndex] = toSave;

    return YES;
}

- (void) textViewDidChange:(UITextView *)textView
{
    //call updates only if content size crosses the width

    NSString* content = textView.text;
    
    float height = 31;

    if([self calcSize:content].height > height ){
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    
}

- (CGSize)calcSize:(NSString *)text
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {

        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGRect frame = [text boundingRectWithSize:CGSizeMake(274, FLT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attributes
                                      context:nil];

        return frame.size;
    } else {
        return [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(274, FLT_MAX)];
    }
}

- (CGSize)text:(NSString *)text constrainedToSize:(CGSize)size
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGRect frame = [text boundingRectWithSize:size
                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                       attributes:attributes
                                          context:nil];
                NSLog(@"Bound size: height %f", size.height);
        NSLog(@"Bound size: width %f", size.width);
        NSLog(@"Frame size: height %f", frame.size.height);
        NSLog(@"Frame size: width %f", frame.size.width);
        return frame.size;
    }
    else
    {
        return [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"num rows %d", [self.toDoItems count]);
    
    return [self.toDoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ToDoCell";
    ToDoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(cell != nil){
        cell.todoTextView.delegate = self;
        cell.todoTextView.text = [self.toDoItems objectAtIndex:indexPath.row];
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"Trying to delete row: %d", [indexPath row]);
        NSString* toDelete = [self.toDoItems objectAtIndex:[indexPath row]];
        NSLog(@"Trying to delete : %@", toDelete);
        [self.toDoItems removeObjectAtIndex:[indexPath row]];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //update core data
        
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < self.toDoItems.count) {
    
        NSLog(@"Calculating height for content %@", [self.toDoItems objectAtIndex:indexPath.row]);
    
        NSString* content = [self.toDoItems objectAtIndex:indexPath.row];
        float horizontalPadding = 40;
    
        float widthOfTextView = self.tableView.bounds.size.width;
        widthOfTextView = widthOfTextView - horizontalPadding;
    
        float height = [self text:content constrainedToSize:CGSizeMake(widthOfTextView, FLT_MAX)].height;
    
    
        if(height < 35){
            height = 35.0;
        }
    
        NSLog(@"Content height: %f", height);
    
        return height + 15;
    } else {
        NSLog(@"RowHeight: %f", self.tableView.rowHeight);
        return self.tableView.rowHeight;
    }

}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *stringToMove = [self.toDoItems objectAtIndex:fromIndexPath.row];
    [self.toDoItems removeObjectAtIndex:fromIndexPath.row];
    [self.toDoItems insertObject:stringToMove atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) // Don't move the first row
        return NO;
    
    return YES;
}

#pragma mark - Instance methods

- (void)addNewToDo{
    
    //update the NSMutableArray
    //call reload on table
    [self.toDoItems insertObject:@"" atIndex:0];
    [self.tableView reloadData];
    
    //move cursor to new table row
    NSIndexPath* index = [NSIndexPath indexPathForRow:0 inSection:0];
    NSLog(@"Num cells %d", [self numberOfSectionsInTableView:self.tableView]);
    NSLog(@"index %d",[self.toDoItems count]);
    NSLog(@"index %d",index.row);
    ToDoCell* firstResponder = (ToDoCell*)[self.tableView cellForRowAtIndexPath:index];
    [firstResponder.todoTextView becomeFirstResponder];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
}

- (void)hideKeyboard{
    [self.view endEditing:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addNewToDo)];
}

@end
