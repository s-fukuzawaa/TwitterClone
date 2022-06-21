//
//  TweetCell.h
//  twitter
//
//  Created by Airei Fukuzawa on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (nonatomic, strong) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *replyNum;
@property (weak, nonatomic) IBOutlet UILabel *rtwtNum;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;
@end

NS_ASSUME_NONNULL_END
