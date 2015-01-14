# Oculus
Visualization of real-time public geo-tagged Instagram photos via a heat map

## Description
Oculus enables users to discover interesting things around them by looking at pictures taken from different places in real time. The pictures are retrieved from the Instagram API and are displayed on a map according to their geo-tag. The user has the option to click on a specific picture and get more information regarding the picture. Finally, a heatmap visualization displays on overview of the volume of the latest pictures according to the location on the map.

## Screenshots
![image](/images/1.png)  ![image](/images/2.png)  ![image](/images/3.png)
![image](/images/4.png)  ![image](/images/6.png)  ![image](/images/7.png)
![image](/images/8.png)  ![image](/images/9.png)  ![image](/images/10.png)

## APIs used

#### [Google Places API](https://developers.google.com/places/)
Used for information about place search in the first view of the application. It is also used to get the suggested auto-completion results while search.

#### [Google Geocoding API](https://developers.google.com/maps/documentation/geocoding/)
Retrieves the area, city and state from a set of coordinates. It is used for displaying the location a photo was taken.

#### [Instagram Real Time Photo Updates API](http://instagram.com/developer/realtime/)
Retrieves the latest location tagged photo’s taken from people with public profiles on Instagram.

## Frameworks used

#### [Date Tools](https://github.com/MatthewYork/DateTools)
Streamlines date and time handling. Used for calculating and displaying the time that has passed since a photo was taken.

#### [SD Web Image](https://github.com/rs/SDWebImage)
Asynchronous image downloader with cache support. Used for downloading images in image view throughout the application.

#### [MB Progress HUD](https://github.com/matej/MBProgressHUD)
iOS activity indicator. Used for displaying a “loading” overlay when the list/grid view is pulled down for fetching new images.

#### [Reachability](https://github.com/tonymillion/Reachability)
Internet connection verification tool. Used for checking if a valid internet connection exists before making any web API calls. 

#### [Parse Database](https://parse.com/docs/ios_guide#top/iOS)
Database SDK for iOS. Used for saving user information in the cloud. 

#### [Facebook Login](https://developers.facebook.com/docs/ios/)
Facebook authentication SDK. Used for enabling a user to login to the application with his Facebook account. Used in combination with parse. 

#### [Heat Map](https://github.com/ryanolsonk/HeatMapDemo)
Map Kit overlay for visualizing location based data sets. Used for visualizing 

## Additional Details
This application was developed as the final group project for the class COMS6998 in the Spring 2014 at Columbia University. The following members also contributed to the project:

Dimitris Paidarakis
Ajay Siva
Prateek Sinha