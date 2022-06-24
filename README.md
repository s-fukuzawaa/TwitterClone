# Project 2 - *Twitter Clone*

**Twitter Clone** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **18** hours spent in total

## User Stories

The following **core** features are completed:

**A user should**

- [x] See an app icon in the home screen and a styled launch screen
- [x] Be able to log in using their Twitter account
- [x] See at latest the latest 20 tweets for a Twitter account in a Table View
- [x] Be able to refresh data by pulling down on the Table View
- [x] Be able to like and retweet from their Timeline view
- [x] Only be able to access content if logged in
- [x] Each tweet should display user profile picture, username, screen name, tweet text, timestamp, as well as buttons and labels for favorite, reply, and retweet counts.
- [x] Compose and post a tweet from a Compose Tweet view, launched from a Compose button on the Nav bar.
- [x] See Tweet details in a Details view
- [x] App should render consistently all views and subviews in recent iPhone models and all orientations

The following **stretch** features are implemented:

**A user could**

- [x] Be able to **unlike** or **un-retweet** by tapping a liked or retweeted Tweet button, respectively. (Doing so will decrement the count for each)
- [x] Click on links that appear in Tweets
- [ ] See embedded media in Tweets that contain images or videos
- [x] Reply to any Tweet (**2 points**)
  - Replies should be prefixed with the username
  - The `reply_id` should be set when posting the tweet
- [x] See a character count when composing a Tweet (as well as a warning) (280 characters) (**1 point**)
- [ ] Load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client
- [x] Click on a Profile image to reveal another user's profile page, including:
  - Header view: picture and tagline
  - Basic stats: #tweets, #following, #followers
- [ ] Switch between **timeline**, **mentions**, or **profile view** through a tab bar (**3 points**)
- [ ] Profile Page: pulling down the profile page should blur and resize the header image. (**4 points**)

The following **additional** features are implemented:

- [x] Compose tweet view has user profile
- [x] When character count reaches limit, gives warning by changing text color to red

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Autolayout. I want to learn more about how to make view compatible with different iphone models.
2. How to organize duplicate code. The view outlet assignment consists large chunks of code that can be organized.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![Kapture 2022-06-24 at 16 02 42](https://user-images.githubusercontent.com/31524675/175723718-c0e00df1-62bc-4c84-8a66-5e6c881b7545.gif)

GIF created with [Kap](https://getkap.co/).

## Notes

I had trouble doing autolayout with the view components. Some labels were overlapping. I also struggled to implement the hyperlink since I never learned it before. I had to research what is the best way online.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [UITextViewPlaceholder](https://github.com/AFNetworking/AFNetworking](https://github.com/devxoul/UITextView-Placeholder)
- [DateTools] (https://github.com/MatthewYork/DateTools)
- [FRHyperLabel] (https://github.com/null09264/FRHyperLabel) (Attempt to use hyperlabel)

## License

    Copyright [2022] [Airei Fukuzawa]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
