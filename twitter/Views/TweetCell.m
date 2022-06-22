//
//  TweetCell.m
//  twitter
//
//  Created by Airei Fukuzawa on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell
- (IBAction)didTapFavorite:(id)sender {
    self.tweet.favorited = !self.tweet.favorited;
    if(self.tweet.favorited == YES){
        self.tweet.favoriteCount += 1;
    }else{
        self.tweet.favoriteCount -= 1;
    }
    [self refreshDataFavorite];
    self.reply.titleLabel.text = NULL;
}
- (IBAction)didTapRetweet:(id)sender {
    self.tweet.retweeted = !self.tweet.retweeted;
    if(self.tweet.retweeted == YES){
        self.tweet.retweetCount += 1;
    }else{
        self.tweet.retweetCount -= 1;
    }
    [self refreshDataRtwt];
    self.reply.titleLabel.text = NULL;
//    TODO: Need to implement retweet by user?
}

- (void) refreshDataFavorite {
//    Update count
    [self.likes setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
//    Case when favored:
    if(self.tweet.favorited == YES) {
        UIImage *btnImage = [UIImage imageNamed:@"favor-icon-red"];
        [self.likes setImage:btnImage forState:UIControlStateNormal];

//        Call favorite api manager method

        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }else{
//        Case when unfavored:
        UIImage *btnImage = [UIImage imageNamed:@"favor-icon"];
        [self.likes setImage:btnImage forState:UIControlStateNormal];
//        Call unfavor api manager method
        [[APIManager shared] unfavor:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
    }

}

- (void) refreshDataRtwt {
//    Update retweet count
    [self.rtwt setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
    
    
    if(self.tweet.retweeted == YES) {
//        Case: retweeted
        UIImage *btnImage = [UIImage imageNamed:@"retweet-icon-green"];
        [self.rtwt setImage:btnImage forState:UIControlStateNormal];
//        Call retweet API
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
             }
         }];
    }else{
//        Case: unretweet
        UIImage *btnImage = [UIImage imageNamed:@"retweet-icon"];
        [self.rtwt setImage:btnImage forState:UIControlStateNormal];
//        Call retweet API
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
             }
         }];
    }
    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
