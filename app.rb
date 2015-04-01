require 'active_record'
require 'pg'
require 'pry'

require_relative 'db/connection'
require_relative 'lib/category'
require_relative 'lib/flashcard'


def print_menu
  puts "\n----------------------Menu----------------------
  1. Create a new flashcard
  2. View all flashcards
  3. Edit a flashcard
  4. Delete a flashcard
  5. Create a category
  6. View cards by category
  7. Test yourself (Warning: Your last score will be reset)
  8. View score/recent answers
  9. Quit program"
end

def print_all_flashcards(flashcards_to_print)
  counter = 1
  flashcards_to_print.all.each do |flashcard|
    puts "_" * terminal_size()[0]
    puts "|\n|#{counter}. #{flashcard}"
    puts "-" * terminal_size()[0]

    counter += 1
  end

end

def terminal_size
    `stty size`.split.map { |x| x.to_i }.reverse
end


def print_all_categories
  puts "-------------------Categories-------------------"
  puts Category.all
end


def get_new_flash_info
  new_flash_category = get_category_from_user
  new_flash_question = get_question_from_user
  #Add validation error if question is not unique
  new_flash_answer = get_answer_from_user

  return {front:new_flash_question, back:new_flash_answer, status:"unanswered", category_id:Category.find_by(name:new_flash_category).id}
end

def create_new_flashcard
  print_all_categories
  Flashcard.create(get_new_flash_info)
end


def get_new_category_info
  puts "What should the new category be?"
  new_flash_category = gets.chomp.downcase.capitalize
  return {name:new_flash_category, score:0}
end

def create_new_category
  puts "hi"
  Category.create(get_new_category_info)
end


def get_category_from_user
  puts "\nChoose a category from the above"
  return gets.chomp.downcase.capitalize
end

def get_question_from_user
  puts "\nWhat should the question be?"
  return gets.chomp
end

def get_answer_from_user
  puts "\nWhat is the answer?"
  return gets.chomp
end

def print_flashcards_for_category
  print_all_categories
  card_category = get_category_from_user
  category_id = Category.find_by(name:card_category).id
  print_all_flashcards(Flashcard.where(category_id:category_id))
  return(Flashcard.where(category_id:category_id))
end


while true
  print_menu
  puts "Please make a choice from the above"
  user_choice = gets.chomp.to_i

  case user_choice

  when 1
    create_new_flashcard

  when 2
    # print all instances of the Flashcard object
    system("clear")
    print_all_flashcards(Flashcard.all)

  when 3
    #Edit a flashcard
    system("clear")

    selected_flashcards = print_flashcards_for_category

    puts "Please enter the number of the flashcard you'd like to edit"
    card_to_edit = gets.chomp.to_i

    puts "Do you want to edit the question? (Yes or No)"
    if gets.chomp.downcase == "yes"
      selected_flashcards[card_to_edit-1].front = get_question_from_user
    end

    puts "Do you want to edit the answer? (Yes or No)"
    if gets.chomp.downcase == "yes"
      selected_flashcards[card_to_edit-1].back = get_answer_from_user
    end

    selected_flashcards[card_to_edit-1].save
    puts selected_flashcards[card_to_edit-1]

  when 4
    #Delete a flashcard
    system("clear")

    selected_flashcards = print_flashcards_for_category

    puts "Please enter the number of the flashcard you'd like to delete"
    card_to_edit = gets.chomp.to_i
    selected_flashcards[card_to_edit-1].destroy

  when 5
    create_new_category

  when 6
    #  6. View cards by category
    system("clear")
    print_flashcards_for_category

  when 7
    #  Test yourself (Warning: Your last score will be reset)
    system("clear")

    puts "To resume from last test, type 'resume'"
    puts "To start new test, type 'new'"
    resume_or_start_over = gets.chomp

    if resume_or_start_over == "new"
      # prompt user for the category they'd like to test themselves on
      print_all_categories
      puts "For which category would you like to test yourself? (Type exit at any time)"
      category_to_view = gets.chomp.downcase.capitalize

      selected_category = Category.find_by(name:category_to_view)
      selected_category.active_test = true

      not_selected_categories = Category.where.not(name:category_to_view)
      not_selected_categories.active_test = false

      #Reset the score for each category:
      selected_category.score = 0
      selected_category.save

      #Reset the status of each flashcard in that category:
      flashcards_in_category.each do |card|
        card.status = "unanswered"
        card.save
      end

    elsif resume_or_start_over == "resume"
      selected_category = Category.find_by(active_test:true)
      flashcards_in_category = Flashcard.where(category_id:selected_category.id)
    else
      puts "invalid choice"
    end



    flashcards_in_category = Flashcard.where(category_id:selected_category.id)

    # Find the number of unanswered questions in that category
    num_of_unanswered_questions = flashcards_in_category.size
    # puts num_of_unanswered_questions
    num_of_incorrect_answers = flashcards_in_category.where(status:"incorect").size
    # puts num_of_incorrect_answers

    # while num_of_unanswered_questions > 0 || num_of_incorrect_answers > 0

    num_correct = 0
    test_status = ""
    #while there are incorrect or unanswered questions
    while num_correct < flashcards_in_category.size && test_status != "break"

      #look at each flashcard
      flashcards_in_category.each do |card|
        # if test_status == "exit"
        #   break
        # end
        #if the card is unanswered or incorrect
        if card.status != "correct"

          #test the usuer
          puts card.front
          puts "Provide your answer:"
          user_answer = gets.chomp.downcase

          #if the user wants to exit the test
          if user_answer == "exit"
            puts "hi"
            test_status = "break"
            puts test_status
            break

            #if their answer is correct
          elsif card.back.downcase == user_answer
            card.user_answer = user_answer
            puts "CORRECT!!"

            #update the card status
            card.status = "correct"

            #update the category score
            selected_category.score += 1

            #update the number of correct answers
            num_correct += 1
            card.save

            #else if their answer is incorrect
          else

            card.user_answer = user_answer

            puts "INCORRECT"

            #update the card status
            card.status = "incorrect"
            card.save
          end

          #save any changes
          selected_category.save

        end
      end
      
      puts "You've finished the test!"
    end



  when 8
    #View score/recent answers
    system("clear")

    print_all_categories
    puts "For which category would you like to view your score?"
    category_to_view = gets.chomp.downcase.capitalize

    selected_category = Category.find_by(name:category_to_view)
    flashcards_to_view = Flashcard.where(category_id:selected_category.id)

    puts "Last score: #{selected_category.score}"
    puts "Recent answers"
    puts "------------------------------------------------"
    flashcards_to_view.all.each do |flashcard|
      puts "\n User_answer: #{flashcard.user_answer}"
    end


  when 10
    break

end
end



# binding.pry
