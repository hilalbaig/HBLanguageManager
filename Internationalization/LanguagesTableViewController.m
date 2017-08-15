//
//  LanguagesTableViewController.m
//  Internationalization
//
//  Created by Hilal Baig on 5/2/17.
//  Copyright © 2017 HilalB. All rights reserved.
//


#import "LanguagesTableViewController.h"

#import "AppDelegate.h"

#import <AFNetworking/AFNetworking.h>
#import "SSZipArchive.h"


typedef void (^DownloadCompletionBlock)(BOOL success);


@interface LanguagesTableViewController () {
    NSArray *languages;
    
}

@end

@implementation LanguagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    languages = [HBLanguageManager languageStrings];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ELanguageCount;//languages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = languages[indexPath.row];
    if (indexPath.row == [HBLanguageManager currentLanguageIndex]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self zipPath:@"demo.zip"]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self zipPath:@"demo.zip"] error:nil];
    }
    
    
    
    NSArray *languageDownloadUrls  = [HBLanguageManager languageDownloadUrls];
    NSString *filePath = languageDownloadUrls[indexPath.row];
    NSURL *langUrl = [NSURL URLWithString:filePath]; //ur.lproj url
    
    //show hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loading";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [self downloadLocalizableStringsFromServer:langUrl completion:^(BOOL success) {
            
            
            if (success) {
                // load localized bundle
                [HBLanguageManager saveLanguageByIndex:indexPath.row];
                
                //hide hud
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self reloadRootViewController];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            } else {
                // load localized bundle
                [HBLanguageManager saveLanguageByIndex:indexPath.row];
                
                //hide hud
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self reloadRootViewController];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
        }];
        
    });
    
    
}



-(void)downloadLocalizableStringsFromServer:(NSURL*)langUrl completion:(DownloadCompletionBlock)completion {
    
    
    
    //afnetworking
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.URLCache = nil;
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    


    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:langUrl];
    

    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        return [NSURL fileURLWithPath:[self zipPath:[response suggestedFilename]]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSString *zipPath = [self zipPath:[response suggestedFilename]];
        NSString *unzipPath = [self unzipPath];
        
        
        NSError *errorrr;
        
        BOOL success = [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&errorrr];
        if (!success) {
            NSLog(@"failed to unzip.. %@",errorrr.localizedDescription);
        } else {
            NSLog(@"File unziped to: %@", unzipPath);
        }
        
        completion(success);
        
        
        
    }];
    
    [downloadTask resume];
    
}






- (void)reloadRootViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}


-(NSString*)zipPath:(NSString*)filename {
    
    NSString *tmpDirectory = NSTemporaryDirectory();
    return [tmpDirectory stringByAppendingPathComponent:filename];
    
    
}


-(NSString*)unzipPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *unzipPath = [documentsDirectory stringByAppendingPathComponent:CUSTOM_BUNDLE_NAME];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:unzipPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:unzipPath withIntermediateDirectories:YES attributes:nil error:&error]; //Create folder
        
    }
    
    return unzipPath;
    
}



@end

        

