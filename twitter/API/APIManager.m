//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"
#import "User.h"

static NSString * const baseURLString = @"https://api.twitter.com";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    
    // TODO: fix code below to pull API Keys from your new Keys.plist file
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

    NSString *key = [dict objectForKey: @"consumer_Key"];
    NSString *secret = [dict objectForKey: @"consumer_Secret"];
    
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    // APIManager.m
    // Create a GET Request
    [self GET:@"1.1/statuses/home_timeline.json"
       parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
           // Success
           NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];
           completion(tweets, nil);
        for(Tweet* twt in tweets){
            NSLog(@"%@", twt.text);
        }
//        [task resume];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           // There was a problem
           completion(nil, error);
    }
    
    ];
    
}

// TODO: Post Composed Tweet Method
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
- (void)postStatusWithTextReply:(NSString *)text status_id: (NSString *) status_id completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text, @"in_reply_to_status_id": status_id};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)getUser:(void(^)(NSDictionary *userDict, NSError *error))completion {
    
    [self GET:@"1.1/account/settings.json"
        parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable temp) {
           // Success
//           NSString *screenName = temp[@"screen_name"];
//        NSLog(@"HEYYYEEYEHEH");
//        NSLog(@"%@",screenName);
           completion(temp, nil);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           // There was a problem
           completion(nil, error);
   }];
}

- (void)getMyself:(NSString*) username completion:(void(^)(User *user, NSError *error)) completion{
    NSString* getString = [@"1.1/users/show.json?screen_name=" stringByAppendingString:username];
    [self GET:getString
        parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable userDict) {
        // Success
        User *user = [[User alloc]initWithDictionary:userDict];
        NSLog(@"HEYYYEEYEHEH");
        completion(user, nil);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           // There was a problem
           completion(nil, error);
   }];
}

//GET https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=twitterapi&count=2
- (void)getUserTimeline:(NSString*) username completion:(void(^)(NSArray *tweets, NSError *error)) completion{
    NSString* getString = [@"1.1/statuses/user_timeline.json?screen_name=" stringByAppendingString:username];
    // Create a GET Request
    [self GET:getString
       parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
           // Success
           NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];
           completion(tweets, nil);
//        [task resume];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           // There was a problem
           completion(nil, error);
    }];
}


- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {

    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unfavor:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {

    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSDictionary *parameters = @{@"id": tweet.idStr};
    NSString *appendedId = [tweet.idStr stringByAppendingString:@".json"];
    
    NSString *urlString = [@"1.1/statuses/retweet/" stringByAppendingString:appendedId];
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSDictionary *parameters = @{@"id": tweet.idStr};
    NSString *appendedId = [tweet.idStr stringByAppendingString:@".json"];
    
    NSString *urlString = [@"1.1/statuses/unretweet/" stringByAppendingString:appendedId];
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
    
}
@end
