# Project 3 - *Tweetmeister*

**Tweetmeister** is a basic twitter app to read and compose tweets from the [Twitter API](https://apps.twitter.com/).

Time spent: **35** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] The current signed in user will be persisted across restarts.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

The following **additional** features are implemented:


- [x] Attributed link for videos and photos
- [x] Attributed mentions (@), clicking on it takes user to Profile Details
- [x] Attributed hashtag, clicking on which fetches more tweets for that hashtag
- [x] Media Image in timeline tweet and details view 
- [x] Clicking on profile pic on home timeline opens profile details
- [x] Spring Animations for buttons
- [x] Quick Actions (Retweet,Reply and Like) on home timeline 
- [x] If a tweet has multiple mentions, hitting reply on it adds all mentions directly to compose reply
- [x] Verified icon for verified users
- [x] Enable/Disable Tweet button 
- [x] Twitter like placeholder while composing a tweet
- [x] Auto Caps for sentences while composing a tweet
- [x] Progress HUD


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Play video in app?! 


## Video Walkthrough

Here's a walkthrough of implemented user stories:

![Video Walkthrough](tweetmeister-take2.gif)


GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes
I am not sure if I am doing something wrong or if there is something wrong with my xcode. I came across a bunch of pods which specifically mentioned that the support Xcode 8 and Swift 3. After pod install however, I always had to Convert to Swift 3 and the pod had a ton of conversion errors. I ended up having to manually add the pod folder which worked but it would be nice for pods to do their job. 


## License

    Copyright 2016 Saurabh Patwardhan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
