FlashCards App

We're going to be building a FlashCard management application, which allows a user to create, read, update and delete flashcards.

Menu Spec:
When starting the application, the user has the following options:
- Create a new flashcard
- View all flashcards
- Edit a flashcard
- Delete a flashcard
- Create a category
- View cards by category
- Test yourself (Warning: Your last score will be reset)
- View score/recent answers
- Quit program

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

A flashcard may not be blank. If there is a question on one side, there must be an answer on the other. A flashcard does not need to have a category.

When a user tests his or herself, his or her last score is replaced by the new score.
