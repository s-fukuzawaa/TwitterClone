//
//  TweetCell.h
//  twitter
//
//  Created by Airei Fukuzawa on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TweetCellDelegate;


@interface TweetCell : UITableViewCell
@property (nonatomic, strong) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *reply;
@property (weak, nonatomic) IBOutlet UIButton *rtwt;
@property (weak, nonatomic) IBOutlet UIButton *likes;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property (nonatomic, strong) NSDate *date;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (void) formatDate;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

@end
@protocol TweetCellDelegate
// TODO: Add required methods the delegate needs to implement
- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;

@end
NS_ASSUME_NONNULL_END
