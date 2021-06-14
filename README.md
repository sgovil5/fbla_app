# Resudent
<p align="center">
<img src="https://user-images.githubusercontent.com/54728068/103335903-82587980-4a44-11eb-9919-cc75da9d6160.png" alt="Resudent" width=200>
</p>

FBLA Mobile App Development 2020-2021\
Marvin Ridge High School\
Team Members: Shitij Govil and Vibhu Gomatam

# Correlation
**Resudent is a social platform that utilizes a profile, friend, and chat system to give students interested in their professional careers a platform to meet others. Resudent forms large networks of people interested in specific topics throught the world, and it allows students to learn from each other. Resudent is a novel idea in the fact that it is targeted specifically towards students, which no apps have done before.**

# Features
- [Login](#Login) (Internal and Facebook)
- [Your Profile](#Your-Profile)
- [Friends](#Friends)
- [Chat](#Chat)
- [Search](#Search)
- [Report Bug and Suggestions](#Report-Bug-and-Suggestions)

## Login
- User has the ability to create an account using the **Sign Up** button. 
    * Requires an Email, School, User Image, Short Description about the user, Username, and Password.
    * Alternatively, the user may sign up using their Facebook account.
- User has the ability to **Log In** to an existing account with the Login button.
    * Requires Email and Password.
    * Alternatively, the user may log in with their Facebook account.
- User Authentication is handled by the Firebase Authentication API and user data is stored in Cloud Firestore.
    * User Authentication for Facebook is handled through both the Firebase Authentication API and the Facebook Authentication API.
## Your Profile
- Displays basic profile information. 
    * Name, School, Description, and a Profile Picture uploaded from the device.
    * Data stored in Cloud Firestore.
        * Image stored in Firebase Storage.
- Displays academic and extracurricular information.
    * Classes, Test Scores, Topics of Interest, Achievements, Volunteer, and Work Experience.
    * Stored in Cloud Firestore.
- User can edit their Username, Profile Picture, and School as well as the 'Description', 'Classes', 'Test Scores', 'Interests', 'Achievements', and 'Experiences' categories.
    * An edit profile button at the top-right navigates user to the edit profile page.
    * For each category, a user can add a field or remove a field.
        * A '+' icon for each category allows users to add a field to a specific category.
        * A garbage-bin icon for each field allows users to delete a specific field from a category.
    * A pop-up allows users to edit a specific field for the category they choose.
## Search
- Search for users using categories. 
    * Seach by name of user.
    * Search by common interests of user.
    * Search by schools of user.
- Searching returns a clickable preview of others' profiles based upon the type of query.
    * Preview contains User Image, Username, and School.
    * Clicking on the preview navigates the user to the profile page of the selected user.
        * Contains data about their Name, School, Description Profile Picture, Classes, Test Scores, Topics of Interest, Achievements, Volunteer, and Work Experience.
        * Displays two buttons that allows others to make friends and chat with the selected user.
## Friends
- Users can send friend requests to each other by visiting others' profile page and clicking the friend request icon.
    * This sends a request to the selected user who has the option to accept or decline the request.
- Users can view their friends and pending requests on a separate page, allowing for quick access to their profile.
- All data pertaining to friends and pending requests is stored in Cloud Firestore.
## Chat
- Users can create chats with anyone by navigating to the desired user's page and clicking the chat icon.
    * Clicking the icon will either create a new chat if one doesn't exist, or navigate to an already existing chat.
- Users can see all their chats from a separate page that displays a clickable preview of the other users the current user is chatting with.
    * Clicking on this preview will open up the existing chat.
- Users can send messages back-and-forth that are stored indefinitely. 
- All data pertaining to chats is stored in Cloud Firestore.
## Report Bug and Suggestions
- Allows user to report any problems, bugs, or suggestions.
    * User may input contact information.
- Reports sent to Cloud Firestore.
## Navigation Bar
- My Profile: takes user to the my profile page. 
- Friends: takes user to friends page, where they can accept/decline friend requests and navigate to friend profiles.
- Chat: takes user to chat page, where they can locate existing chats.
- Search: allows user to search by name, school, or interests.
- Other: takes user to a page where they can report a bug or logout.

# Instructions to Run This App
These are the instructions to run the files on GitHub on a local device.
## Prerequisites
- [Install Git](https://git-scm.com/downloads)
- [Install Flutter](https://flutter.dev/docs/get-started/install)
  * Choose the correct operating system and follow the outlined steps
## Clone this app on VS Code
- [Install VS Code](https://code.visualstudio.com/)
- Copy the following URL: https://github.com/horsefeedapples/fbla_app.git and then open VS Code
  * Open the Command Pallet on VS Code by typing `ctrl+shift+p` and type Git: Clone and press enter
  * Select the folder where the files should be downloaded
- Get all the dependencies and packages by typing `flutter pub get` into the command prompt
- The app is ready to run
## Clone this app on Android Studio
- [Install Android Studio](https://developer.android.com/studio/install)
- Copy the following URL: https://github.com/horsefeedapples/fbla_app.git and open Android Studio
  * Click "Check out project from Version Control" and select "Git"
  * Paste the URL and select the desired directory location for the project. Then click the clone button
  * If prompted "Would you like to create an Android Studio project for the sources you have check out," select "No."
  * When prompted to open the project, choose the existing project and click OK
  * When the project is open in Android Studio, type `flutter pub get` into the command prompt to get all dependecies
- The app is ready to run

# Technical Specifications
- Made with the Flutter plugin for the Dart Language.
- Google's Firebase used for Database, Data Storage(for Image), and User Authentication.
    * Connected to app through RESTful API.
    * Create, Read, Update, and Delete operations used.
- Native support for both iOS and Android.

## Analytics
- Analytics for various categories are available. Categories include:
    * Number of Facebook and regular users.
    * Location, Demographics, Devices, and Interests of users.
    * User retention and engagement.
    * Document Read and Writes.
   
## Packages Used
- [Cloud Firestore](https://pub.dev/packages/cloud_firestore) - By firebase.google.com
- [Firebase Auth](https://pub.dev/packages/firebase_auth) - By firebase.google.com
- [Firebase Storage](https://pub.dev/packages/firebase_storage) - By firebase.google.com
- [Image Picker](https://pub.dev/packages/image_picker) - By flutter.dev
- [Flutter Login Facebook](https://pub.dev/packages/flutter_login_facebook) - By innim.ru
- [Provider](https://pub.dev/packages/provider) - By dash-overflow.net
- [Flutter SignIn Button](https://pub.dev/packages/flutter_signin_button) - By Liu Zhiheng

# Planning
- [Sprint Planning](https://timelines.gitkraken.com/timeline/2584802811ab43aa848879d1b361c815?range=0_22)
- [Sprint Storyboard](https://app.gitkraken.com/glo/board/X-PBLLw5GgAS446I)
- [App Design](https://www.figma.com/file/Hcma6qqDZZJ8mWkQaJQloB/FBLA-App)

# License
[MIT License](https://github.com/horsefeedapples/fbla_app/blob/master/LICENSE) 

