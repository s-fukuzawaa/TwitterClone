//
//  ComposeViewController.h
//  twitter
//
//  Created by Airei Fukuzawa on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (weak, nonatomic) NSString *username;
@property (weak, nonatomic) NSString *idStr;
@end

NS_ASSUME_NONNULL_END
