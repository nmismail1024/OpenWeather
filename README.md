# Open Weather
Sample iOS app that displays a the current weather and 7 day forecast. User can choose between 2 themes, and switch between Celcius and Farenheit.

**iOS Mobile App:**
1. Displays the current weather and 7 day forecast based on the user's current location.
2. Weather data is received in JSON format via Open Weather Map api, by using a separate call for the daily and 7 day forecast data.
3. If there is an error, such as unable to retrieve location, or weather, then user can tap the screen to retry.
4. Has two user switchable themes, Sea and Forest. Currently forecast background theme images are limited to CLOUDY, RAINY and SUNNY.
5. User can toggle Temperature display between Celcius and Farenheit.
6. Includes some simple animations when initially displaying the weather to improve look to the user.
7. Coded using MVVM pattern.
8. Includes basic test cases for the view model.
9. Includes basic UI test cases.
10. Intended as a simple sample app, but the weather display is fully functional.
11. Please use own custom API_KEY if updating the app.

**Sample Screenshots:**
<div align="center">
  <img src="/Screenshots/OpenWeather_SplashScreen.png" alt="Launch Screen" title="Splash Screen" width="25%" height="25%" hspace="20" />
  <img src="/Screenshots/OpenWeather_MainScreen_SeaTheme.png" alt="Main Screen. Sea Theme." title="Main Screen. Sea Theme." width="25%" height="25%" hspace="20" />
  <img src="/Screenshots/OpenWeather_MainScreen_ForestTheme.png" alt="Main Screen. Forest Theme." title="Main Screen. Forest Theme." width="25%" height="25%" hspace="20" />
  <img src="/Screenshots/OpenWeather_SeaTheme_Farenheit.png" alt="Main Screen. Farenheit Display." title="Main Screen. Farenheit Display." width="25%" height="25%" hspace="20" />
</div>
