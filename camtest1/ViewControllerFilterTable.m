//
//  ViewControllerFilterTable.m
//  camtest1
//
//  Created by dev on 12/5/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "ViewControllerFilterTable.h"
#import "Filter.h"

@interface ViewControllerFilterTable ()
{
    NSArray *filters;
}

@end

@implementation ViewControllerFilterTable

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
    filters = [Filter filters];
    [[self tableView] reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // Return the number of rows in the section.
    return [filters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"effect_cell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier
                             forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    Filter *filter = [filters objectAtIndex:[indexPath row]];
    cell.textLabel.text = [filter name];
    cell.detailTextLabel.text = [filter description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
    UIImage *newImage = [[filters objectAtIndex:[indexPath row]]
                         applyFilterToImage:[self.state.meta.image image]];
    self.state.meta.image.image = newImage;
    [self.state.meta updateUnsavedChangeDate];
    
    [[self tabBarController] setSelectedIndex:0];
}

@end
