//
//  ComposeViewController.m
//  twitter
//
//  Created by Airei Fukuzawa on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>



@interface ComposeViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *twtView;
@property (weak, nonatomic) IBOutlet UILabel *wordCount;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (nonatomic, strong) NSString *myUsername;
@property (nonatomic, strong) NSDictionary *setting;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.twtView.delegate = self;
    self.twtView.layer.cornerRadius = 8;
    self.twtView.layer.borderWidth = 1.0f;
    self.twtView.placeholder = @"What's happening?";
    self.twtView.placeholderColor = [UIColor lightGrayColor]; // optional

    self.twtView.layer.borderColor = [[UIColor systemBlueColor] CGColor];
    // set wordcount label
    self.wordCount.text = @"0/140";
    self.wordCount.textColor = [UIColor systemBlueColor];
    if(self.username !=NULL){
        self.twtView.text = [@"@" stringByAppendingString:self.username];
    }
    
    [[APIManager shared] getUser:^(NSDictionary *userDict, NSError *error) {
            if (userDict) {
                NSLog(@"SCNREE NAME");
                self.myUsername = userDict[@"screen_name"];
                [[APIManager shared] getMyself:self.myUsername completion:^(User *user, NSError *error) {
                    if (user) {
                        NSLog(@"%@", user);
                        
                        NSString *URLString = user.profilePicture;

                        NSURL *url = [NSURL URLWithString:URLString];
                        NSData *urlData = [NSData dataWithContentsOfURL:url];
                        [self.profilePic setImage: [UIImage imageWithData:urlData]];
                    } else {
                        NSLog(@"😫😫😫 Error getting url : %@", error.localizedDescription);
                    }
                }];
            } else {
                NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
            }
        }];
        
}
- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)tweetButton:(id)sender {
    if(self.username!=NULL){
        [[APIManager shared]postStatusWithTextReply:self.twtView.text
                                     status_id: self.idStr
                                    completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            }
            else{
                [self.delegate didTweet:tweet];
                NSLog(@"Compose Tweet Success!");
            }
        }];
    }else{
        [[APIManager shared]postStatusWithText:self.twtView.text completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            }
            else{
                [self.delegate didTweet:tweet];
                NSLog(@"Compose Tweet Success!");
            }
        }];
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.twtView.text stringByReplacingCharactersInRange:range withString:text];

    // TODO: Update character count label
    if(newText.length<characterLimit){
        self.wordCount.text = [NSString stringWithFormat:@"%lu/140",newText.length];
        self.wordCount.textColor = [UIColor systemBlueColor];
    }else{
        self.wordCount.text = @"140/140";
        self.wordCount.textColor = [UIColor redColor];
    }

    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
    // TODO: Check the proposed new text character count
    
    // TODO: Allow or disallow the new text
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
