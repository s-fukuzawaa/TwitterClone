//
//  DetailsViewController.m
//  twitter
//
//  Created by Airei Fukuzawa on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"


@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *twtContent;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *retweet;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UIButton *retwtButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // assign date
    self.date.text = self.tweet.createdAtString;
    // main name
    self.name.text = self.tweet.user.name;
    // username
    self.username.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    // tweet body
    self.twtContent.text = self.tweet.text;
    //rtwt text setup
    self.retweet.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    if(self.tweet.retweetCount==1){
        self.retweet.text = [self.retweet.text stringByAppendingString:@" Retweet"];
    }else{
        self.retweet.text = [self.retweet.text stringByAppendingString:@" Retweets"];
    }
    //likes text setup
    self.likes.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    if(self.tweet.favoriteCount==1){
        self.likes.text = [self.likes.text stringByAppendingString:@" Like"];
    }else{
        self.likes.text = [self.likes.text stringByAppendingString:@" Likes"];
    }
    
    //like button setup
    [self.likeButton setTitle:@"" forState:UIControlStateNormal];
    if(self.tweet.favorited){
        UIImage *btnImage = [UIImage imageNamed:@"favor-icon-red"];
        [self.likeButton setImage:btnImage forState:UIControlStateNormal];
    }else{
        UIImage *btnImage = [UIImage imageNamed:@"favor-icon"];
        [self.likeButton setImage:btnImage forState:UIControlStateNormal];
    }
    
    //rtwt text and image setup
    [self.retwtButton setTitle:@"" forState:UIControlStateNormal];

    if(self.tweet.retweeted){
        UIImage *btnImage = [UIImage imageNamed:@"retweet-icon-green"];
        [self.retwtButton setImage:btnImage forState:UIControlStateNormal];
    }else{
        UIImage *btnImage = [UIImage imageNamed:@"retweet-icon"];
        [self.retwtButton setImage:btnImage forState:UIControlStateNormal];
    }
    
    //set profile picture
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    [self.profile setImage: [UIImage imageWithData:urlData]];
}
- (IBAction)tapRetwt:(id)sender {
    self.tweet.retweeted = !self.tweet.retweeted;
    if(self.tweet.retweeted == YES){
        self.tweet.retweetCount += 1;
    }else{
        self.tweet.retweetCount -= 1;
    }
    [self refreshDataRtwt];
    
//    [self.delegate didAction];
//    TODO: Need to implement retweet by user?
}
- (IBAction)tapLike:(id)sender {
    self.tweet.favorited = !self.tweet.favorited;
    if(self.tweet.favorited == YES){
        self.tweet.favoriteCount += 1;
    }else{
        self.tweet.favoriteCount -= 1;
    }
    [self refreshDataFavorite];
    
}

- (void) refreshDataFavorite {
//    Update count
    //likes text setup
    self.likes.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    if(self.tweet.favoriteCount==1){
        self.likes.text = [self.likes.text stringByAppendingString:@" Like"];
    }else{
        self.likes.text = [self.likes.text stringByAppendingString:@" Likes"];
    }
    
//    Case when favored:
    if(self.tweet.favorited == YES) {
        UIImage *btnImage = [UIImage imageNamed:@"favor-icon-red"];
        [self.likeButton setImage:btnImage forState:UIControlStateNormal];

//        Call favorite api manager method

        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                 [self.delegate didAction];

             }
         }];
    }else{
//        Case when unfavored:
        UIImage *btnImage = [UIImage imageNamed:@"favor-icon"];
        [self.likeButton setImage:btnImage forState:UIControlStateNormal];
//        Call unfavor api manager method
        [[APIManager shared] unfavor:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                 [self.delegate didAction];

             }
         }];
    }

}
- (void) refreshDataRtwt {
//    Update retweet count
    self.retweet.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    if(self.tweet.retweetCount==1){
        self.retweet.text = [self.retweet.text stringByAppendingString:@" Retweet"];
    }else{
        self.retweet.text = [self.retweet.text stringByAppendingString:@" Retweets"];
    }
    
    
    if(self.tweet.retweeted == YES) {
//        Case: retweeted
        UIImage *btnImage = [UIImage imageNamed:@"retweet-icon-green"];
        [self.retwtButton setImage:btnImage forState:UIControlStateNormal];
//        Call retweet API
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                 [self.delegate didAction];

             }
         }];
    }else{
//        Case: unretweet
        UIImage *btnImage = [UIImage imageNamed:@"retweet-icon"];
        [self.retwtButton setImage:btnImage forState:UIControlStateNormal];
//        Call retweet API
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
                 [self.delegate didAction];

             }
         }];
    }
    

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
