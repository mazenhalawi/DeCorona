# DeCorona
A sample Swift mobile app project developed using VIPER design pattern. 

The app is divided into three scenes. 
(i) Location Permission Scene
(ii) Notification Permission Scene
(iii) Status Scene

(i) Location Permission Scene:
This is launched on the first run of the app. The scene describes the use of Location services so that the user can allow access to the service. Location service is vital so that we determine user's coordinates and query the API for the directions needed to display to the user. The location service installed in the app makes use of significant location changes which gets triggered in the background and notify user of location changes.

(ii) Notification Permission Scene:
This is launched on the first run of the app right after the Location Permission Scene. Notification permission is required to notify the user of location change as well as changes in corona virus status which is triggered from the background tasks which runs every 10 minutes.

(iii) StatusScene
This is the main scene of the app. It displays the full UI concept of the app. The user's current location and coordinates, cases_per_100k value, number of cases, deaths, death rate and last updated. The background color of the indicator changes according to the cases_per_100k value. 

  Green Phase (Neutral):    Between 0 and 35 
  Yellow Phase (Warning):   Between 35 and 50
  Red Phase (Danger):       Between 50 and 100
  Purple Phase (Critical):  Over 100
  
  The general guidelines are statically shown at the bottom of the page.
  
  
  Some graphic design icons are available in the graphic folder. They were created mostly with Adobe Illustrator.
  
  Unit and UI Tests were implemented. Due to the short time, only the main tests were conducted. 
