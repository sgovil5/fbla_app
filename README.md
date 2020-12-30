# Resudent
<p align="center">
<img src="https://user-images.githubusercontent.com/54728068/103335903-82587980-4a44-11eb-9919-cc75da9d6160.png" alt="Resudent" width=300>
</p>

## FBLA Mobile App Development 2020-2021
## Marvin Ridge High Schoo;
## Team Members: Shitij Govil and Vibhu Gomatam

An Application created for _Mobile Application Development_, an FBLA Competitive Event. Its purpose is to connect students with others, including but not limited to students, teachers, and organizations.


# Features
- [Login](#Login)
- [Your Profile](#Your-Profile)
- [Edit Profile](#Edit-Profile)
- [Friends](#Friends)
- [Search](#Search)
- [Report Bug](#Report-Bug)

    
## Login
- User has the ability to create an account using the Sign Up button. 
    * Requires an Email, School, User Image, Short Description, Username, and Password.
    * Alternatively, the user may sing up using Facebook.
- User has the ability to log in to an existing account with the Login button
    * Requires Email and Password
    * Alternitavely, the user may log in with Facebook.
- User Authentication is handled by the Firebase Authentication API and user data is stored in Cloud Firestore
## Your Profile
- Displays basic profile information. 
    * Name, School, Description, and a Profile Picture uploaded from the device.
    * Stored in Cloud Firestore
- Displays academic and extracurricular information.
    * Classes, Test Scores, Topics of Interest, Awards, Volunteer, and Work Experience.
    * Stored in Cloud Firestore
- User can edit the 'Description', 'Classes', 'Test Scores', 'Interests', 'Achievements', and 'Experiences' categories.
    * An edit profile button at the top-right navigates user to the edit profile page
    * For each category, a user can add a field or remove a field.
        * A '+' icon for each category allows users to add a field to a specific category
        * A garbage-bin icon for each field allows users to delete a specific field from a category.
    * A pop-up allows users to edit a specific field for the category they choose.
## Search
- Search for users using categories. 
    * Seach by name of users
    * Search by common interests of users
    * Search by schools of users
- Searching returns a clickable preview of others' profiles based upon the type of query.
    * Preview contains User Image, Username, and School
    * Clicking on the preview navigates the user to a page with all details of the selected user
        * Contains data about their Name, School, Description Profile Picture, Classes, Test Scores, Topics of Interest, Awards, Volunteer, and Work Experience.
        * Displays two buttons that allows others to make friends and chat with the selected user.
## Friends
- Users can send friend requests to each other by visiting others' profile page and clicking the friend request icon.
    * This sends a request to the selected user who has the option to accept or decline the request.
- Users can view their friends and pending requests on a separate page which allows them for quick access to their profile.
- All data about friends and prending requests is stored in Cloud Firestore.
## Chat
- Users can create chats with anyone by navigating to the desired user's page and clicking the chat icon.
    * Clicking the icon will either create a new chat if one doesn't exist, or navigate to an already existing chat
- Users can see all their chats from a separate page that displays a clickable preview of the other users the current user is chatting with.
    * Clicking on this preview will open up the existing chat
- Users can send messages back-and-forth that are stored indefinitely. 
- All data pertaining to chats is stored in Cloud Firestore
## Report Bug and Suggestions
- Allows user to report any problems, bugs, or suggestions.
    * User may input contact information.
## Navigation Bar
- My Profile: takes user to the my profile page. 
- Friends: takes user to friends page, where they can accept/decline friend requests and navigate to friend profiles.
- Chat: takes user to chat page, where they can find the users they had a chat with
- Search: allows user to search by name, school, or interests.
- Other: takes user to a page where they can report a bug or logout.

# Technical Details
- Made with the Flutter plugin for the Dart Language
- Google's Firebase used for Database, Data Storage, and User Authentication
- Native support for both iOS and Android

## Packages Used
- [Cloud Firestore](https://pub.dev/packages/cloud_firestore) - By firebase.google.com
- [Firebase Auth](https://pub.dev/packages/firebase_auth) - By firebase.google.com
- [Firebase Storage](https://pub.dev/packages/firebase_storage) - By firebase.google.com
- [Image Picker](https://pub.dev/packages/image_picker) - By flutter.dev

# Licence
[MIT Licence](https://github.com/horsefeedapples/fbla_app/blob/master/LICENSE) 

