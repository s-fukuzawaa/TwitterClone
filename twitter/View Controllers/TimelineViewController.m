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
@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

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
            for (Tweet *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
                NSLog(@"%@", dictionary.text);
            }
            // TimelineViewController.m
            self.arrayOfTweets = (NSMutableArray*)tweets;
            self.tableView.dataSource = self;
            self.tableView.delegate = self;

//            NSLog(@"%@", self.arrayOfTweets);
            [self.tableView reloadData];

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
    Tweet* twt=self.arrayOfTweets[indexPath.row];
    cell.displayName.text = cell.tweet.user.name;
    cell.userName.text = cell.tweet.user.screenName;
    cell.tweetText.text = cell.tweet.text;
    //rtwt text and image setup
    [cell.rtwt setTitle:[NSString stringWithFormat:@"%d", twt.retweetCount] forState:UIControlStateNormal];

    if(cell.tweet.retweeted){
        UIImage *btnImage = [UIImage imageNamed:@"retweet-icon-green"];
        [cell.rtwt setImage:btnImage forState:UIControlStateNormal];
    }else{
        UIImage *btnImage = [UIImage imageNamed:@"retweet-icon"];
        [cell.rtwt setImage:btnImage forState:UIControlStateNormal];
    }
    //likes text and image setup
    [cell.likes setTitle:[NSString stringWithFormat:@"%d", twt.favoriteCount] forState:UIControlStateNormal];
    if(cell.tweet.favorited){
        UIImage *btnImage = [UIImage imageNamed:@"favor-icon-red"];
        [cell.likes setImage:btnImage forState:UIControlStateNormal];
    }else{
        UIImage *btnImage = [UIImage imageNamed:@"favor-icon"];
        [cell.likes setImage:btnImage forState:UIControlStateNormal];
    }
    //reply button should not have text
    cell.reply.titleLabel.text = NULL;
    //message button should not have text
    cell.messageButton.titleLabel.text = NULL;
    NSString *URLString = cell.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    [cell.profilePic setImage: [UIImage imageWithData:urlData]];
    return cell;
//    return NULL;
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl {

    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (Tweet *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
            // TimelineViewController.m
            self.arrayOfTweets = (NSMutableArray*)tweets;
            [self fetchTweets];
            NSLog(@"%@", self.arrayOfTweets);

        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
    
}

- (void)didTweet:(Tweet *)tweet{
    [self fetchTweets];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
}


- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];

}
@end
