//
//  EntreRenewTableVC.m
//  Entre
//
//  Created by Michael Holp on 7/11/14.
//  Copyright (c) 2014 Fovnders. All rights reserved.
//

#import "EntreRenewTableVC.h"
#import <SBJson/SBJson4.h>
#import "EntreDetailsVC.h"
#import "ASIFormDataRequest.h"

@implementation EntreRenewTableVC
@synthesize renewDict;

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
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    logo.image = [UIImage imageNamed:@"entre-logo.png"];
    [self.view addSubview:logoView];
    [logoView addSubview:logo];
    self.navigationItem.titleView = logoView;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:173/255.0 green:216/255.0 blue:199/255.0 alpha:1.0];
    self.tableView.backgroundColor = [UIColor colorWithRed:173/255.0 green:216/255.0 blue:199/255.0 alpha:1.0];
    
    [self fetchSpaces];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[renewDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]][@"title"] uppercaseString];
    cell.detailTextLabel.text = [renewDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]][@"custom_fields"][@"address"][0];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [renewDict count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *sectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, self.tableView.frame.size.width, 18)];
    [sectionLbl setFont:[UIFont boldSystemFontOfSize:14]];
    [sectionLbl setTextColor:[UIColor whiteColor]];
    sectionLbl.text = [renewDict objectForKey:[NSString stringWithFormat:@"%ld",(long)section]][@"taxonomy_places"][0][@"title"];
    [view setBackgroundColor:[UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1.0]];
    [view addSubview:sectionLbl];
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.textColor = [UIColor colorWithRed:73/255.0 green:162/255.0 blue:142/255.0 alpha:1.0];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:173/255.0 green:216/255.0 blue:199/255.0 alpha:1.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntreDetailsVC *details = [self.storyboard instantiateViewControllerWithIdentifier:@"EntreDetails"];
    details.placeName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    details.address = [NSString stringWithFormat:@"%@, %@", [renewDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]][@"custom_fields"][@"address"][0], [renewDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]][@"custom_fields"][@"city"][0]];
    details.hours = [renewDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]][@"custom_fields"][@"working_hours"][0];
    details.phone = [renewDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]][@"custom_fields"][@"phone_number"][0];
    details.excerpt = [renewDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]][@"excerpt"];
    details.content = [[renewDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]][@"content"] isEqualToString:@""] ? @"" : [renewDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]][@"content"];
    details.type = @"Renew";
    [self.navigationController pushViewController:details animated:YES];
}

- (void)fetchSpaces
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://entre.co/api/get_recent_posts/?post_type=renewal"]];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *err;
    NSString *jsonString = [request responseString];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
    
    int j=0;
    renewDict = [[NSMutableDictionary alloc] init];
    for(int i=0; i<[tempDict[@"posts"] count]; i++){
        if(tempDict[@"posts"][i][@"custom_fields"][@"parent"]){
            [renewDict setObject:tempDict[@"posts"][i] forKey:[NSString stringWithFormat:@"%d", j]];
            j+=1;
        }
    }
    
    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Entre Alert" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
