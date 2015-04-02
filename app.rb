require 'active_record'
require 'pg'
require 'pry'

require_relative 'db/connection'
require_relative 'lib/category'
require_relative 'lib/flashcard'

# binding.pry
def clear
  system("clear")
end

def get_user_input(message)
  puts message
  gets.chomp
end

def create_new_category
  new_category_from_user = get_user_input("\nWhat should the new category be?").downcase.capitalize
  new_category = Category.new(name:new_category_from_user, score:0)
  if new_category.valid?
    new_category.save
    puts "New category - #{new_category.name} - created."
  else
    new_category.errors.full_messages
  end
end

def create_new_flashcard
  print_all_categories
  new_flashcard = get_new_flashcard_info
  if new_flashcard.valid?
    new_flashcard.save
  else
    puts new_flashcard.errors.full_messages
  end

end

def get_new_flashcard_info
  new_flash_category = get_user_input("\nWhat should the category be?").downcase.capitalize
  new_flash_question = get_user_input("\nWhat should the question be?")
  new_flash_answer = get_user_input("\nWhat is the answer?")
  new_flashcard = Flashcard.new(front:new_flash_question, back:new_flash_answer, status:"Unanswered", user_answer: "n/a", category_id:Category.find_by(name:new_flash_category).id)
  return new_flashcard
end

def print_flashcards_for_a_category
  print_all_categories
  card_category = get_user_input("\nChoose a category.").downcase.capitalize
  category_id = Category.find_by(name:card_category).id
  print_selected_flashcards(Flashcard.where(category_id:category_id))
  return(Flashcard.where(category_id:category_id))
end

def print_all_categories
  puts"-------------------Categories-------------------"
  puts Category.all
  puts"------------------------------------------------"
end

def print_selected_flashcards(flashcards_to_print)
  counter = 1
  flashcards_to_print.all.each do |flashcard|
    puts "#{counter}:"
    puts "#{flashcard}"
    counter += 1
  end
  if counter == 1
    puts "There are no flashcards to print."
  end
end

def print_menu
  puts "\n----------------------Menu----------------------
  1. Create a new flashcard
  2. View all flashcards
  3. Edit a flashcard
  4. Delete a flashcard
  5. Create a category
  6. View cards by category
  7. Test yourself
  8. View score/recent answers
  9. Quit program"
end

def terminal_size
  `stty size`.split.map { |x| x.to_i }.reverse
end

def titleize(text)
  dashes = "-" * ((terminal_size()[0]/2)-(text.size/2))
  title = dashes + text + dashes + "\n\n"
  puts title
end


system("clear")
while true
  print_menu
  puts "Please make a choice from the above"
  user_choice = gets.chomp.to_i

  case user_choice

  when 1
    clear
    titleize(" CREATE A NEW FLASHCARD ")
    create_new_flashcard

  when 2
    clear
    titleize(" VIEW ALL FLASHCARDS ")
    print_selected_flashcards(Flashcard.all)

  when 3
    clear
    titleize(" EDIT FLASHCARD ")
    print_all_categories
    selected_category = Category.find_by(name:get_user_input("\nChoose a category.").downcase.capitalize)
    selected_flashcards = Flashcard.where(category_id:selected_category.id)
    print_selected_flashcards(selected_flashcards)
    card_to_edit = get_user_input("Please enter the number of the flashcard you'd like to edit").to_i

    new_flashcard = get_new_flashcard_info
    if !new_flashcard.valid?
      puts new_flashcard.errors.full_messages
    else
      old_flashcard = selected_flashcards[card_to_edit-1]
      selected_flashcards[card_to_edit-1] = new_flashcard
      selected_flashcards[card_to_edit-1].save
      old_flashcard.destroy
      puts "\nEdited Flashcard:\n#{selected_flashcards[card_to_edit-1]}"
    end

  when 4
    clear
    titleize(" DELETE A FLASHCARD ")

    print_all_categories
    selected_category = Category.find_by(name:get_user_input("\nChoose a category.").downcase.capitalize)
    selected_flashcards = Flashcard.where(category_id:selected_category.id)
    print_selected_flashcards(selected_flashcards)
    card_to_edit = get_user_input("Please enter the number of the flashcard you'd like to delete. (Or type 'exit')").to_i

    selected_flashcards[card_to_edit-1].destroy
    puts "Your card has been successfully deleted."

  when 5
    clear
    titleize(" CREATE A NEW CATEGORY ")
    create_new_category

  when 6
    clear
    titleize(" VIEW CARDS BY CATEGORY ")
    print_all_categories
    selected_category = Category.find_by(name:get_user_input("\nChoose a category.").downcase.capitalize)
    selected_flashcards = Flashcard.where(category_id:selected_category.id)
    print_selected_flashcards(selected_flashcards)

  when 7
    clear
    titleize(" TEST YOURSELF ")

    puts "To resume from last test, type 'resume'"
    puts "To start new test, type 'new'"
    resume_or_start_over = gets.chomp


    if resume_or_start_over == "new"
      # prompt user for the category they'd like to test themselves on
      print_all_categories
      puts "For which category would you like to test yourself? (Type exit at any time)"
      category_to_view = gets.chomp.downcase.capitalize

      if category_to_view == "Exit"
        next
      end

      #Set the selected category to active
      selected_category = Category.find_by(name:category_to_view)
      selected_category.active_test = true

      #Remove active status of all other category
      not_selected_categories = Category.where.not(name:category_to_view)
      not_selected_categories.all.each do |category|
        category.active_test = false
        category.save
      end

      #Reset the score for each category:
      selected_category.score = 0
      selected_category.save

      #Find all the flashcards in the selected category
      flashcards_in_category = Flashcard.where(category_id:selected_category.id)

      #Reset the status and user answer of each flashcard in that category:
      flashcards_in_category.each do |card|
        card.status = "Unanswered"
        card.user_answer = ""
        card.save
      end

      num_correct = 0

    elsif resume_or_start_over == "resume"
      #find the last category tested
      selected_category = Category.find_by(active_test:true)
      if selected_category == nil
        puts "You have no test to resume"
        next
      end
      flashcards_in_category = Flashcard.where(category_id:selected_category.id)
      num_correct = flashcards_in_category.where(status:"correct").size

    else
      puts "That is an invalid choice"
      next
    end


    test_status = ""
    #while there are incorrect or unanswered questions
    while num_correct < flashcards_in_category.size && test_status != "break"

      #look at each flashcard
      flashcards_in_category.each do |card|

        #if the card has not been answered correctly
        if card.status != "Correct"

          #test the usuer
          puts card.front
          puts "Provide your answer:"
          user_answer = gets.chomp

          #if the user wants to exit the test
          if user_answer == "exit"
            test_status = "break"
            break

            #if their answer is correct
          elsif card.back.downcase == user_answer.downcase
            card.user_answer = user_answer
            puts "CORRECT!!"

            #update the card status
            card.status = "Correct"
            card.save

            #update the category score
            selected_category.score += 1
            selected_category.save

            #update the number of correct answers
            num_correct += 1

            #else if their answer is incorrect
          else
            card.user_answer = user_answer
            puts "INCORRECT"

            #update the card status
            card.status = "Incorrect"
            card.save
          end
        end
      end
    end
    puts "\nYou are done with the #{selected_category.name} test! Your current score is #{selected_category.score} out of #{flashcards_in_category.size}."
    puts "Your grade is #{((selected_category.score.to_f/flashcards_in_category.size)*100).round}%"
    puts "Try again or try a new test."

  when 8
    clear
    titleize(" VIEW SCORE/RECENT ANSWERS ")

    print_all_categories
    selected_category = Category.find_by(name:get_user_input("\nChoose a category.").downcase.capitalize)
    selected_flashcards = Flashcard.where(category_id:selected_category.id)

    puts "\nLast score: #{selected_category.score}. Grade: #{((selected_category.score.to_f/selected_flashcards.size)*100).round}%."
    puts "Recent answers"
    puts "------------------------------------------------"
    selected_flashcards.all.each do |flashcard|
      puts "\nQUESTION: #{flashcard.front}"
      puts "YOUR LAST ANSWER: #{flashcard.user_answer}"
      puts "STATUS: #{flashcard.status}"
    end

  when 9
    clear
    titleize(" EXITED ")
    break


  end
end



# binding.pry
