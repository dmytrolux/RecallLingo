# Recall Lingo

## The goal of the project
This project, called "RecallLingo", was created to meet the personal needs of such an application and went all the way from idea to implementation. The main goal of the project is to provide users with a convenient and effective tool for translating English words and phrases into Ukrainian, with the possibility of learning and memorizing new words, using regular reminders in the form of notifications with the opportunity to test their knowledge.

## Frameworks Used

-  MLKitTranslate: Used for implementing the translation feature.
- SwiftUI and UIKit: Utilized for designing and customizing the user interface.
- WebKit: Used for displaying external links.
- Combine: Employed for handling data streams.
- CoreData: Used for managing the dictionary of words.
- HidableTabView: Utilized for convenient hiding of TabView.
- AVFoundation: Used for speech synthesis.
- StoreKit: Utilized for app rating functionality.
- Network: Used for monitoring network connectivity.

## Localization
The RecallLingo project has been localized in both Ukrainian and English languages, allowing users to interact with the app in their preferred language.

## Installation Requirements
To use this project, you need to have Xcode installed and the CocoaPods dependency manager. 
Note: The project was developed in Xcode 14.3, using Swift 5.8, and targets devices running iOS 15.5 or later.

##  Installation
1. Download this project.

2. Open the terminal.

2.1. Navigate to the project directory in the terminal (e.g., cd /Users/currentUser/Desktop/RecallLingo) on Mac.

2.2. Install the necessary pods by running the command: pod install.

2.3. Open RecallLingo.xcworkspace in the project folder
 
 3. You're all set! Select a Device or Simulator, build, and run.
 
 4. If you encounter any issues with packages, follow these steps:

4.1. In Xcode, go to Project Navigator.
  
  4.2. Select Package Dependencies.
  
  4.3. Resolve Package Version.

## Usage
### 1) Translator and Word Addition:
<p align="center"><img src="https://github.com/salokpi/RecallLingo/assets/50060543/ddefabb3-2c9f-4618-8c13-4bf3ad855603" width=300>
<p align="center">"Screenshot: Translator"</p>

In the Translate tab, the user can input English text (word or phrase). Upon tapping the send button, they will receive the Ukrainian translation, which will be automatically added to the dictionary stored in Core Data. The added word will be marked with a colored flag. If the user wishes to remove the translation and not save it, they can tap the flag to delete the word from the dictionary. However, the word will remain in the chat until the user restarts the app. Each translation request in the chat increases the "popularity" property of the corresponding word. The received translation can be edited by long-pressing on it.
In this window, the user can also listen to the pronunciation of English words by tapping on the message containing the English word. Tapping the dynamic icon that appears will immediately cancel the pronunciation. If autoSpeak is enabled in the settings, each new translation will be automatically voiced.

### 2) Dictionary Viewing and Management:
<p align="center"><img src="https://github.com/salokpi/RecallLingo/assets/50060543/8a8376c7-668f-431f-9d2b-341c28a904a5" width=300>
<p align="center">"Screenshot: Dictionary"</p>

The dictionary is populated with words from the chat. Only English words are displayed in the dictionary. A popularity indicator is shown to the left of each word. If the indicator is red, the word may appear in a notification. The user can sort words by the date of their addition to the dictionary, alphabetically, or by popularity. Through a swipe action, the user can reset the popularity or delete a word.
By tapping on a word, the user can open the word card.

### 3) Word Card:
<p align="center"><img src="https://github.com/salokpi/RecallLingo/assets/50060543/b3893891-b777-493d-ad1b-db0307396218" width=300>
<p align="center">"Screenshot: Word Card"</p>

The word card presents the English word/phrase and its Ukrainian translation, along with the popularity indicator and the date of the first translation. Each time the card is opened, the word's popularity increases. In this screen, the user can listen to the pronunciation of the English word and edit or delete the translation.

### 4) Statistics:
This tab displays the total number of words in the dictionary and the most popular word.

### 5) App Settings:
<p align="center"><img src="https://github.com/salokpi/RecallLingo/assets/50060543/fa579ea4-902f-4f9a-9754-f664d269b7a9" width=300>
<p align="center">"Screenshot: Setting"</p>
When notifications are enabled, the user receives periodic notifications containing words from the dictionary with the highest popularity. The frequency of notifications can be adjusted by the user. Depending on the user's preference, notifications can either display the correct translation or provide a hint in the form of the first and last letters.

### 6) Interaction cases with received notification:
<p align="center"><img src="https://github.com/salokpi/RecallLingo/assets/50060543/83f11e31-a16d-4504-b5df-24e1ff5e576c" width=300>
<p align="center">"Screenshot: Received a notification"</p>
a) Clicking on the notification and navigating to the word confirmation window: A window will appear where the user must enter the Ukrainian translation. If the translation is correct, the word's popularity will be reset, and the next notification will feature a different word. In the case of an incorrect input, the popularity will increase, and after a certain interval, the user will receive the notification with the same word again.

b) Clicking on the "Check me" action: It will execute case "a".

c) Clicking on the "I know this word" action: The word's popularity will be automatically reset. After a certain interval, the user will receive the notification with another popular word.

d) Clicking on the "I don't know this word" action: The word card with the translation will open, and the word's popularity will increase. After a certain interval, the user will receive the notification with the same word again.

## Contributing
If you would like to contribute to the project, you can:

### 1) Clone the repository:
```
https://github.com/salokpi/RecallLingo.git»
```
### 2)Create a new branch for your contribution:
```
"git checkout -b feature/your-feature"
```
### 3) Make the necessary changes and commit:
```
"git commit -m "Add your commit message""
```
### 4) Push your branch to the repository:
```
"git push origin feature/your-feature"
```
### 5) Open a pull request on GitHub with your changes.

## Authors:
The idea for the "RecallLingo" project was conceived by Oleh Dovhan, but it was independently implemented by Dmytro Pryshliak and published on the App Store under Oleh Dovhan's account.






