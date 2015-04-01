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
    puts "\n#{counter}. #{flashcard}"
    counter += 1
  end
  puts
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

    # Print all categories:   print_all_categories
    # Prompt for category: get_category_from_user
    # Show all Flashcards for that category:
    #   category_id = Category.find_by(name:flash_category).id
    #   print_all_flashcards(Flashcard.where(category_id:category_id))

    #or to simplify: print_flashcards_for_category
    #get user input for flashcard to edit
    #get_question_from_user
    #get_answer_from_user
    #update selected Flashcard with new question and answer

  when 4
    #Delete a flashcard

    # Print all categories:   print_all_categories
    # Prompt for category: get_category_from_user
    # Show all Flashcards for that category:
    #   category_id = Category.find_by(name:flash_category).id
    #   print_all_flashcards(Flashcard.where(category_id:category_id))

    #or to simplify: print_flashcards_for_category
    #get user input for flashcard to delete
    #destroy slected flashcard




  when 5
    create_new_category

  when 6
    system("clear")

    #Combine the next four lines into a method:  print_flashcards_for_category
    print_all_categories
    flash_category = get_category_from_user
    category_id = Category.find_by(name:flash_category).id
    print_all_flashcards(Flashcard.where(category_id:category_id))

  when 7
    #  Test yourself (Warning: Your last score will be reset)

  when 8
    #View score/recent answers


  when 9
    break

end
end
binding.pry
