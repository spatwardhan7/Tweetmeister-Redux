# Project 4 - *Tweetmeister-Redux*

Time spent: **20** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Hamburger menu
   - [x] Dragging anywhere in the view should reveal the menu.
   - [x] The menu should include links to your profile, the home timeline, and the mentions view.
   - [x] The menu can look similar to the example or feel free to take liberty with the UI.
- [x] Profile page
   - [x] Contains the user header view
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timeline
   - [x] Tapping on a user image should bring up that user's profile page

The following **optional** features are implemented:

- [x] Profile Page
   - [x] Implement the paging view for the user description.
   - [x] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [x] Pulling down the profile page should blur and resize the header image.

The following **additional** features are implemented:

- [x] Media Image inside tweet cell 
- [x] Attributed hashtags, mentions and urls
- [x] Attributed urls in profile scroll view 
- [x] Use xibs for profile cell and tweet cell

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

  1. Account Switching
  2. Pull down guesture on Profile Page


## Video Walkthrough

Here's a walkthrough of implemented user stories:

![Video Walkthrough](tweetmeister-redux-take1.gif)


GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I had to rebuild most of my existing project to start using xibs. After that, implementing scroll view for profile page took all of my time. I had over looked certain issues which crept up during this implementation. 

Also, licecap cannot capture video as is. Especially the profile view where it cannot quite capture the page control and the background image. I bumped it up to 24 FPS, any higher than that and it will probably result in gif's bigger than 100 MB 

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