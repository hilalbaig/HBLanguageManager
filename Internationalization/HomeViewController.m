//
//  HomeViewController.m
//  Internationalization
//
//  Created by Hilal Baig on 5/2/17.
//  Copyright © 2017 HilalB. All rights reserved.
//

#import "HomeViewController.h"
#import "LanguagesTableViewController.h"



@interface HomeViewController () <LanguagesTableViewControllerDelegate> {
    NSMutableArray *dataSource;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [NSMutableArray new];

    
    NSDictionary *data = @{
                           @"title":NSLocalizedString(@"Full Name", @""),
                           @"detail":NSLocalizedString(@"Muhammad Hilal Baig", @"")
                           };
    
    
    
    
    
    [dataSource addObject:data];
    [dataSource addObject:data];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controller:(LanguagesTableViewController*)controller didSelectLanguage:(NSString*)language {
    NSLog(@"controller didSelectLanguage: %@",language);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
        NSDictionary *data = dataSource[indexPath.row];
        cell.textLabel.text = [data valueForKey:@"title"];
        cell.detailTextLabel.text = [data valueForKey:@"detail"];
        // Configure the cell...
        
        return cell;
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier2" forIndexPath:indexPath];
        NSDictionary *data = dataSource[indexPath.row];
        UITextField *txtField = [cell viewWithTag:101];
        txtField.text = [data valueForKey:@"detail"];
        
        // Configure the cell...
        
        return cell;
        
    }
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segue.languages"]) {
        LanguagesTableViewController* c = segue.destinationViewController;
        c.delegate = self;
        
    }
}


@end
