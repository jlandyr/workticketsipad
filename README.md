# Work Tickets project for iPad

Swift Xcode project developed specifically for iPad Devices.

The application has the next features:
• Swift is required for this test App
• It is required the use of architecture and design patterns.
• Application needs to be optimized for tablets with 10 Inches, however it needs to be
responsive in order to operate with other resolutions.
• The iOS application needs to work with a local SQL Lite database structure
• The application needs to be able to demonstrate add, modify and delete records
• The application code has proper in code comments and documentation in English.
• For the address location user story, we will be reviewing a proper google maps API
integration

## User Stories

### Login Screen
The Login screen should have the capability for users to type user name and password. The login button must be able to be pressed and login the user after they type their user name and password. If user name or password is incorrect, then an error should be produced when the login button is pressed. If user name and password is correct, then pressing the login in button should take the user to the Dashboard.

### Dashboard
The Dashboard should have a list of tickets with an interactive “view ticket” button that should open up the “work ticket” screen. This list should be in the middle of the screen with “view ticket” button right beside each listed ticket. You need to implement the options of modify and delete tickets.
In the top left corner of the dashboard, there should be a calendar button that opens up an interactive calendar that shows the tickets that are due. There should be sync button beside the calendar button that allows users to sync the calendar to their google calendar.
 
On the top right corner, there should be a “new ticket” button that allows users to enter a new ticket with client name, address and the date the ticket is scheduled for. There should be a “menu” button right beside the “new ticket” button. The menu button should produce a drop- down menu when clicked. The drop-down menu options should be to go to the “work ticket” screen and the “get directions” screen. From the dashboard, users must be able to get to the “work ticket” screen, either by selecting it from the drop-down menu, clicking on a “view ticket” button or by selecting the “new ticket” button, filling out the ticket form and pressing the “save” button.

### Work Ticket
The “work ticket” screen should display the most recent ticket created or the ticket selected from the “dashboard” screen. At the very top of this screen there should be an option to go back to dashboard and there should also be a menu button that lets you go to the “dashboard”, or “get directions” screen.
This “work ticket” screen should show the customers info in the top left corner: Name, phone number and address right below. In the top right corner, there should be the “scheduled for” Date and there should be a section for notes right below that.
At the Bottom of the screen there should be a “Reason for call” section. There should also be interactive buttons right below the reason for call section that take you to different pages. The “overview page” which is were customers first land when getting to the “work ticket” screen. There should be a “work details” button, “purchasing” button, “finishing up” button and a picture logo button. For the purpose of this exercise only the “overview” button has to work.
Where the customer info is, specifically the address, there should be a “get directions” button beside the address. When clicked, this button should take you to the “get directions screen of the application.

### Get Directions
The “Get Directions” screen should produce directions from Google Maps for the address the user clicked on in the previous screen (Work ticket screen). If the user gets to this page by selecting it on the menu, the address spot should be blank for the user to fill out.
The “Get Directions” screen should be able to search the address within Google Maps integration within the APP and you should be able to change the address in case user wants to look up different directions.

### Prerequisites

Requirements for the software and other tools to build, test and push 
- Xcode 13.0
- Swift 4.0
- iPadOS SDK 16.0+

## Authors

  - **Juan Landy** -
    [github](https://github.com/jlandyr)

## License

This project is licensed under the [CC0 1.0 Universal](LICENSE.md)
Creative Commons License - see the [LICENSE.md](LICENSE.md) file for
details
