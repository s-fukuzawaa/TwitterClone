//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "ProfileViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, TweetCellDelegate, DetailsViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
- (IBAction)didTapLogout:(id)sender;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Get timeline
    [self fetchTweets];
    // Initialize a UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}
- (void)fetchTweets {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            // TimelineViewController.m
            self.arrayOfTweets = (NSMutableArray*)tweets;
            self.tableView.dataSource = self;
            self.tableView.delegate = self;

            [self.tableView reloadData];
            self.tableView.rowHeight = UITableViewAutomaticDimension;


        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.arrayOfTweets[indexPath.row];
    cell.delegate = self;

    return cell;
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl {

    [self fetchTweets];
    [self.refreshControl endRefreshing];
    
}

- (void)didTweet:(Tweet *)tweet{
    [self fetchTweets];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            
    }];
}

- (void)didAction{
    [self fetchTweets];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"timelineCompose"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;

    }else if([segue.identifier isEqualToString:@"profileSegue"]){
        ProfileViewController *profileVC = [segue destinationViewController];
        User* user = sender;
        profileVC.user = user;
    }else if([segue.identifier isEqualToString:@"replySegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(TweetCell *)sender];
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        Tweet* twt = self.arrayOfTweets[indexPath.row];
        composeController.username = twt.user.screenName;
        composeController.idStr = twt.idStr;
    }else{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(TweetCell *)sender];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.delegate = self;
        detailVC.tweet = self.arrayOfTweets[indexPath.row];
    }
    
   
}


- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];

}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    // TODO: Perform segue to profile view controller
    [self performSegueWithIdentifier:@"profileSegue" sender:user];


}
@end
