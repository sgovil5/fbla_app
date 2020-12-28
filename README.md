# Resudent

An Application created for _Mobile Application Development_, an FBLA Competitive Event. Its purpose is to connect students with other students, teachers, and companies. 


# Features
- [Login](#Login)
- [Your Profile](#Your-Profile)
- [Edit Profile](#Edit-Profile)
- [Friends](#Friends)
- [Search](#Search)
- [Report Bug](#Report-Bug)

> check if toc works.
> what else to add
<!-- toc -->
    
## Login
- User has the ability to create an account using the Sign Up button. 
    * Requires Email, School, Username, and Password.
    * Alternatively, the user may login using Facebook.
## Your Profile
- Displays basic profile information. 
    * Name, Location, School, Profile Picture (can be uploaded from device).
- Displays academic and extracurricular information.
    * Courses, Test Scores, Topics of Interest, Awards, Volunteer and Work Experience.
## Edit Profile
- Allows user to edit all categories from [About Me](#About-Me).
    * Add and remove Courses, Test Scores, etc.
## Search
- Search for users using categories. 
    * Search by name of user, school of user, interests of user.
    * Note that there are no filter options, it is a simple search.
## Report Bug
- Allows user to report any problems and/or bugs.
    * User may input contact information.
## Chat (INCOMPLETE)
- 
> add info on chat later o_O.

# App Specifications
This app was made using Flutter, and utilizes Google's Firebase as a backend.
- Authorization (the sign-in process), and all other app data is stored and accessed using Firebase.
- As the app was made using Flutter, there is native support for iOS and Android.

# Buttons
- A short description of most, if not all, of the buttons contained in the app.
## Navigation Bar (INCOMPLETE)
- My Profile: takes user to the my profile page. 
- Friends: takes user to friends page, where they can accept/decline friend requests and navigate to friend profiles.
- Chat: 
- Search: allows user to search by name, school, or interests.
- Other: takes user to a page where they can report a bug or logout.

## Login
- Login: allows user to login with correct validation.
- Create An Account: redirects user to the Sign Up page.
- Upload Image: allows user to upload an image from their device to serve as a profile picture.
- Sign Up: allows user to create an account after filling in all required fields. 
## About Me
- Edit Profile: takes user to the edit profile page, where they can edit information on their profile page.
## Edit Profile
These stay similar across categories
- Add: labeled with a "+", lets the user add an item of selected type to display. Note that there are multiple steps to adding an item, and the rest is displayed in a pop-up
- Remove: labeled with a "-", lets the user remove an item of selected type. One step process.
## Search
- Search by name, school, or interests: Press the desired button to search by selected parameter.
## Report Bug
- Allows user to report any problems and/or bugs.
    * User may input contact information.
## Chat (INCOMPLETE)
- 
> add info on chat later o_O.
