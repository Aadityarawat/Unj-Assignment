Setup instructions
1. Open a terminal
2. Navigate to the desired folder
3. Clone the repository by running: git clone https://github.com/Aadityarawat/Unj-Assignment.git
4. The project setup is now complete

Explanation Of My Approach

Library used: 
Dio for network request
SharedPreference for local storage 
flutter_riverpod for state management
git_it for DI
skeletonizer for data loading ui design

HomeScreen:
Implements a user list UI with search and pagination using Riverpod for state management, Navigate to UserDetailScreen or AddUserScreen and stored the data locally.

AddUserScreen:
This is to add new user into the list and stored data locally and navigate to HomeScreen

UserDetailScreen:
This is to displays detailed information about a selected user, using Riverpod for state management and navigation for editing.

EditUserScreen:
The EditUserScreen allows users to edit their details using a form-based UI with validation. It follows a structured ConsumerStatefulWidget approach using Riverpod for state management.

