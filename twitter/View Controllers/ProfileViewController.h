//
//  ProfileViewController.h
//  twitter
//
//  Created by Airei Fukuzawa on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
