//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "Tweet.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;

- (void)postStatusWithTextReply:(NSString *)text status_id: (NSString *) status_id completion:(void (^)(Tweet *, NSError *))completion;


- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)unfavor:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)getUser:(void(^)(NSDictionary *userDict, NSError *error))completion;

- (void)getMyself:(NSString*) username completion:(void(^)(User *user, NSError *error)) completion;
- (void)getUserTimeline:(NSString*) username completion:(void(^)(NSArray *tweets, NSError *error)) completion;

@end
