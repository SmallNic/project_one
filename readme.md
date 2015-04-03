FlashCards App

This FlashCard management application allows a user to create, read, update and delete flashcards.

Menu:
When starting the application, the user has the following options:
- Log in
- Create new account
- Exit

Logging in or creating a new account takes you to the main menu, where you can
- Create a new flashcard
- View all flashcards
- Edit a flashcard
- Delete a flashcard
- Create a category
- View cards by category
- Test yourself (Warning: Your last score will be reset)
- View score/recent answers
- Log out
- Quit program

User Spec:
- has a username
- has a password
- has an email address
- has the last time the user logged in

Flashcard Spec:
- has a front (question)
- has a back (answer)
- has a status (unanswered[default], correctly answered, incorrectly answered)
- if answered, has the user answer
- belongs to a category

Category Spec:
- has a name
- has flashcards
- has a score
- belongs to a user

A flashcard may not be blank. If there is a question on the front, there must be an answer on the other. A flashcard must have a category.

A user can exit the application and resume his or her test at a later time. If a user does not get a question right, it gets added back into the mix and then asked about again until it is answered correctly or until the user starts a new test. When a user tests his or herself, his or her last score is replaced by the new score.
