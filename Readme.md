# Mobile Test

### App Introduction
This app is made using MVVM architecture, the **Main view** is made on storyboard and the **Posts Details view** is made programmatically using auto layout

#### Some Features
 - The posts and author are populated using traditional method, and
   comments are populated using ***RxSwift*** library which is a reactive programming library in iOS app development.
 - A simple error handling is implemented when there are API errors like
   bad URL, decoding errors or network errors.
 - When there is no posts or an error is occurred when loading the   
   posts, the "Delete posts" button is hidden and an image is shown.

### App Installation
##### Requirements
 - [Xcode 13+](https://developer.apple.com/xcode/)

 - [Cocoapods](https://cocoapods.org/)


##### Steps
 - Install Cocoapods with this command on terminal
    ```
    gem install cocoapods
    ```

- Clone or download the project from the repository 

- After `cocoapods` is installed run on the terminal inside project´s root folder:
    
    ```
    pod install
    ```
- Once Pods are created open the project using the following command on the terminal inside project's root folder:
    ```
    xed .
    ```
    Or open by double clicking `MobileTechTest.xcworkspace` inside project´s root folder on Finder
