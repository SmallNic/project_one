while true
  print menu
  get user input
  case user input

  when 1 (view all flashcards)
    print all instances of the Flashcard object

  when 2 (create a new flashcard)
    create new instance of Flashcard object

  when 3 (edit a flashcard)
    print all instances of the Flashcard object
    prompt user for the card they'd like to update
    update an instance of a Flashcard object

  when 4 (delete a flashcard)
    print all instances of the Flashcard object
    prompt user for the card they'd like to delete
    delete an instance of a Flashcard object

  when 5 (create a new category)
    create new instance of Category object

  when 6 (view cards by category)
    print all instances of the Category object
    prompt user for the category they'd like to view
    print all flashcards joined to the selected instance of the Category object

  when 7 (test yourself)
    print all instances of the Category object
    print exit option
    prompt user for the category they'd like to test themselves on
    category score = 0
    for each flashcard in this category
      flashcard status = unanswered
    find num_of_unanswered questions in that category
    while there are unanswered flashcards or while there are incorrectly answered flashcards in the selected category
      print the front of a flashcard
      flashcard_user_answer = prompt the user for the answer
      compare flashcard_user_answer to the stored answer
      if correct
        flashcard status = correctly answered
        score += 1
      else
        flashcard status = incorrectly answered
        num_of_incorrect += 1
      end
      num_of_unanswered -= 1
    end

  when 8 (view score & recent answers)
    print all instances of the Category object
    prompt user for the category they'd like to see their score on
    for that selected category print the score
    for that selected category print the flashcard question and the user answer


  when 9 (quit program)
    break

end
