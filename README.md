# Recipe-App

This is a community based app for sharing and editing your recipes and also viewing other's recipes.
It used Firebase as RTDB (Real Time Database) for its backend.
It also has Auto-login and logout feature.

## For Developers

**Follow the steps given below:**

* Clone the git repo : https://github.com/pranav-prashob-1602/Recipe-App
* Run _pub get_ in the Terminal.
* Create a new project in your Firebase console and get your API KEY 
  - Go to the auth.dart file
    - Comment the following lines
        * import 'dart:io' show Platform;
        * String apiKey = Platform.environment['API_KEY'];
    - Change the url in the authenticate function to the url below and paste your API_KEY in place of [YOUR_API_KEY]
        * final url ='https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=[YOUR_API_KEY]';
 * After all the changes have been done in the code now do the following changes in the project in your firebase console
  - Add Authencication method : Email/Password
  - Change the rules of your Firebase RTDB to
  
      {
      
        "rules": {
        
          ".read": "auth != null",
          
          ".write": "auth != null",
          
          "meals": {
          
            ".indexOn": ["creatorId"]
            
          }
          
        }
        
      } 
      
    and publish it.
* Now you can build and run your project in an emulator.

## For macOS Users

 
I have used a Windows System while developing the project hence I couldn't test with any iOS emulators or real-time devices.
Therefore, I didn't add the required code to the Info.plist for it to work in an iOS device.

Please do the required or you can always run it in a android emulator.

## Features Table

| Feature |	How to do it |
| --- | --- |
| Login/Signup |	Create account and login options are available in the screen that opens up after installation |
| To View Recipe |	(After logging in) Click on any one of the recipe on index/home screen |
| Add to Favourites | (On Home Screen) Click on the star icon on the recipe card |
| To view Favourites | (on the Tabs on the botton of your Screen) Click on the faded Star |
| To view Home Screen | (on the Tabs on the botton of your Screen) Click on the home icon | 
| To open drawer | Click on the icon at the left left corner of your screen |
| To Edit/Add/Delete your recipes | (Inside the Drawer) Click on Manage Products and Click on the Plus sign to add and Edit sign to edit and Delete sign to delete |
| Logout | Click on the logout icon (a door with an arrow) inside the drawer |

## Issues or Bugs with the app?


Contributions are always welcome . You could open up an issue if you feel like something is wrong with the app .


