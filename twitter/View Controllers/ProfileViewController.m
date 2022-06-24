//
//  ProfileViewController.m
//  twitter
//
//  Created by Airei Fukuzawa on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"


@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Get timeline
    [self fetchTweets];
    // set profile
    NSString *URLString = self.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    [self.profileImage setImage: [UIImage imageWithData:urlData]];
    // set backdrop
    NSString *URLStringBanner = self.user.profileBannerUrl;
    NSURL *urlBanner = [NSURL URLWithString:URLStringBanner];
    NSData *urlDataBanner = [NSData dataWithContentsOfURL:urlBanner];
    [self.backImage setImage: [UIImage imageWithData:urlDataBanner]];
    // set name
    self.name.text = self.user.name;
    // set username
    
    self.username.text = [@"@" stringByAppendingString:self.user.screenName];
    // Initialize a UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Set #followers, #following, #tweets label
    self.followersLabel.text = [NSString stringWithFormat:@"%@",self.user.followersCount];
    self.followersLabel.text = [self.followersLabel.text stringByAppendingString:@" followers"];
    self.followingLabel.text = [NSString stringWithFormat:@"%@",self.user.friendsCount];
    self.followingLabel.text = [self.followingLabel.text stringByAppendingString:@" following"];
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%@",self.user.statusesCount];
    self.tweetCountLabel.text = [self.tweetCountLabel.text stringByAppendingString:@" tweets"];
    
}
- (void)fetchTweets {
    // Get timeline
    [[APIManager shared] getUserTimeline:self.user.screenName completion:^(NSArray *tweets, NSError *error) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.arrayOfTweets[indexPath.row];
    cell.delegate = self;

    return cell;
}


- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    // TODO: Perform segue to profile view controller
//    [self performSegueWithIdentifier:@"profileSegue" sender:user];


}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchTweets];
    [self.refreshControl endRefreshing];
}
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
