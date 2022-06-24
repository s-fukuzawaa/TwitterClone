//
//  TweetCell.m
//  twitter
//
//  Created by Airei Fukuzawa on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "NSDate+DateTools.h"
#import "FRHyperLabel.h"

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
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePic addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePic setUserInteractionEnabled:YES];

}

- (void)setTweet:(Tweet *)tweet {
// Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
// _movie was an automatically declared variable with the @propery declaration.
// You need to do this any time you create a custom setter.

    _tweet = tweet;
    // assign date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    self.date = [formatter dateFromString:self.tweet.createdAtString];
    [self formatDate];
    // main name
    self.displayName.text = self.tweet.user.name;
    // username
    self.userName.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    // tweet body
    self.tweetText.text = self.tweet.text;

    NSString *body = self.tweet.text;
    NSDataDetector *detect = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [detect matchesInString:body options:0 range:NSMakeRange(0, [body length])];
    if(matches.count!=0){
        for(NSTextCheckingResult* link in matches){
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:self.tweet.text];
            NSRange range = [self.tweet.text rangeOfString:link.URL.absoluteString];
            [str addAttribute: NSLinkAttributeName value:link.URL range: range ];
            self.tweetTextLink.attributedText = str;
        }
    }else{
        self.tweetTextLink.text = self.tweet.text;
    }
    
    //rtwt text and image setup
    [self.rtwt setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateNormal];

    if(self.tweet.retweeted){
        UIImage *btnImage = [UIImage imageNamed:@"retweet-icon-green"];
        [self.rtwt setImage:btnImage forState:UIControlStateNormal];
    }else{
        UIImage *btnImage = [UIImage imageNamed:@"retweet-icon"];
        [self.rtwt setImage:btnImage forState:UIControlStateNormal];
    }
    //likes text and image setup
    [self.likes setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
    if(self.tweet.favorited){
        UIImage *btnImage = [UIImage imageNamed:@"favor-icon-red"];
        [self.likes setImage:btnImage forState:UIControlStateNormal];
    }else{
        UIImage *btnImage = [UIImage imageNamed:@"favor-icon"];
        [self.likes setImage:btnImage forState:UIControlStateNormal];
    }
    //reply button should not have text
    [self.reply setTitle:@"" forState:UIControlStateNormal];
    //message button should not have text
    [self.messageButton setTitle:@"" forState:UIControlStateNormal];
    //set profile picture
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    [self.profilePic setImage: [UIImage imageWithData:urlData]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) formatDate {
    [self.dateLabel setText: [@" · " stringByAppendingString:[self.date shortTimeAgoSinceNow]]];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    //TODO: Call method delegate
    [self.delegate tweetCell:self didTap:self.tweet.user];

}

@end
