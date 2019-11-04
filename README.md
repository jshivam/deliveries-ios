# deliveries-ios

To run this project, please follow following steps:

1. Open terminal and go to project folder where .podfile is stored.
2. Run pod install / pod update.
3. Once command run successfully, go to project folder and open .xcworkspace file in xcode.

# Requirements

- XCode 11
- MAC 10.15

# Supported iOS Version

- iOS 11.0 +

# Language 

- Swift 5.0


# App Version

- 1.0

# Design Patterns

1. MVVM
2. Adapter design pattern
3. Facade design pattern

Please check below for low level diagram:

![ScreenShot](https://github.com/jshivam/deliveries-ios/blob/master/ScreenShots/architecture.png)

1. View / View Controller - This layer is responsible to handle UI operation based on callback from viewModel class.
2. ViewModel - This layer contains all business logic and list of models.
4. APIHandler - On this layer we have kept logic to parse individual response. This layer is designed by keeping in mind that all checks on server response and parsing will be implemented here. 
5. DataBaseManager - Responsible to handle data from DB.
6. HTTPClient - Responsible to make HTTP api call.

# Caching

1. App using CoreData with Sqlite to make cache of JSON response.
2. For Image caching, App is using third party AlamofireImage.
3. Cache is deleted when App succesfully fetches fresh data from server by using 'Pull to Refresh' feature.

# Assumptions        
1. App support Localization, but for this version app contains only english text.     
2. App support iPhone device in Portrait mode only. 
3.  Supported mobile platforms are iOS (11.x, 12.x, 13.x)        
4.  Device support - iPhone 5s, iPhone 6 Series, iPhone SE, iPhone 7 Series, iPhone 8 Series, iPhone X Series    

# Crashlytics

App has implemented crashlytics using Firebase. 
1. Documentation: https://firebase.google.com/docs/crashlytics/get-started?platform=ios.

# SwiftLint
4. If need to change the rules of swiftlint, goto root folder of the project
5. Open the .swiftlint.yml file and modify the rules based on the requirement

# CocoaPods Used

- Alamofire
- AlamofireImage
- SwiftLint
- Firebase/Analytics
- Fabric
- Crashlytics

# Network Calling

App used native Alamofire for making http call.

# App Data Flow

1. Checks for Records in Data Base
    a. if records exists, display the records from Data Base
    b. if records doesn't exists, make network call
        i. If succesfully fetched records from server, save the records to DB and display the records
       ii. If unsuccesfully fetched records from server, display error 

![ScreenShot](https://github.com/jshivam/deliveries-ios/blob/master/ScreenShots/flowChart.png)


# Displaying Delivery Details

1. Once user select any addess, app shows annotation to selected address on the Apple Map. 

# Pagination Handling

For pagination logic, App will assume more pages till the time it don't get empty list of response from server. In case of offline mode, it will always try for next page ( this is to make sure that if app comes online then it should return response).

# ScreenShots

![ScreenShot](https://github.com/jshivam/deliveries-ios/blob/master/ScreenShots/deliveryList.png)
![ScreenShot](https://github.com/jshivam/deliveries-ios/blob/master/ScreenShots/deliveryDetail.png)

# TODO / Improvements
-  Unit test cases Improvements
-  UI test cases
