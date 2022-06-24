//
//  DetailsViewController.h
//  twitter
//
//  Created by Airei Fukuzawa on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DetailsViewControllerDelegate

- (void)didAction;

@end
@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
