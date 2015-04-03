FlashCards App

We're going to be building a FlashCard management application, which allows a user to create, read, update and delete flashcards.

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

A flashcard may not be blank. If there is a question on one side, there must be an answer on the other. A flashcard does not need to have a category.

When a user tests his or herself, his or her last score is replaced by the new score.
