//
//  User.m
//  twitter
//
//  Created by Airei Fukuzawa on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.profileBannerUrl = dictionary[@"profile_banner_url"];
        self.followersCount = dictionary[@"followers_count"];
        self.friendsCount = dictionary[@"friends_count"];
        self.statusesCount = dictionary[@"statuses_count"];
        self.profileBannerUrl = dictionary[@"profile_banner_url"];
    // Initialize any other properties
    }
    return self;
}
@end
