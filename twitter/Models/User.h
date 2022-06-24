//
//  User.h
//  twitter
//
//  Created by Airei Fukuzawa on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic) NSNumber *followersCount;
@property (nonatomic) NSNumber *friendsCount;
@property (nonatomic) NSNumber *statusesCount;
@property (nonatomic, strong) NSString *profileBannerUrl;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

NS_ASSUME_NONNULL_END
