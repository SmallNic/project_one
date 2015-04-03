require 'active_record'
require 'pg'
require 'pry'
require 'time'

require_relative 'db/connection'
require_relative 'lib/category'
require_relative 'lib/flashcard'
require_relative 'lib/user'


# binding.pry

def clear
  system("clear")
end

def get_user_input(message)
  puts message
  gets.chomp
end

def create_new_category(current_user)
  new_category_from_user = get_user_input("\nWhat should the new category be?").downcase.capitalize
  new_category = Category.new(name:new_category_from_user, score:0, user_id:current_user.id)
  if new_category.valid?
    new_category.save
    puts "New category - #{new_category.name} - created."
  else
    puts new_category.errors.full_messages
  end
end

def create_new_flashcard(current_user)
  print_all_categories(current_user)
  new_flashcard = get_new_flashcard_info(current_user)
  if new_flashcard == nil
    puts "Please try again"
  else
    if new_flashcard.valid?
      new_flashcard.save
    else
      puts new_flashcard.errors.full_messages
    end
  end

end

def get_new_flashcard_info(current_user)
  new_flash_category = get_user_input("\nWhat should the category be?").downcase.capitalize
  if current_user.categories.find_by(name:new_flash_category) == nil
    puts "This category does not exist."
    return nil
  end

  new_flash_question = get_user_input("\nWhat should the question be?")
  new_flash_answer = get_user_input("\nWhat is the answer?")
  new_flashcard = Flashcard.new(front:new_flash_question, back:new_flash_answer, status:"Unanswered", user_answer: "n/a", category_id:Category.find_by(name:new_flash_category).id)
  return new_flashcard
end

def print_all_categories(current_user)
  puts"-------------------Categories-------------------"
  puts current_user.categories.all
  puts"------------------------------------------------"
end

def print_selected_flashcards(flashcards_to_print)
  counter = 1
  flashcards_to_print.all.each do |flashcard|
    puts "#{Category.find_by(id:flashcard.category_id).name} \##{counter}:"
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
  9. Log out
  10. Quit program"
end

def terminal_size
  `stty size`.split.map { |x| x.to_i }.reverse
end

def titleize(text)
  dashes = "-" * ((terminal_size()[0]/2)-(text.size/2))
  title = dashes + text + dashes + "\n\n"
  puts title
end

def get_flashcards_for_category(current_user)
  print_all_categories(current_user)
  category_name = get_user_input("\nChoose a category.")
  selected_category = current_user.categories.find_by(name:category_name.downcase.capitalize)
  if !selected_category
    puts "\nThat category does not exist."
    return nil
  else
    selected_flashcards = Flashcard.where(category_id:selected_category.id)
    return(selected_flashcards)
  end
end

system("clear")
titleize(" F L A S H C A R D S ")
titleize(" Brought to you by Nic Small ")

user_logged_in = false
current_user = nil
while true

  if user_logged_in
    print_menu
    puts "Please make a choice from the above"
    user_choice = gets.chomp.to_i

    case user_choice

    when 1
      clear
      titleize(" CREATE A NEW FLASHCARD ")
      create_new_flashcard(current_user)

    when 2
      clear
      titleize(" VIEW ALL FLASHCARDS ")
      current_user.categories.all.each do |category|
        print_selected_flashcards(category.flashcards.all)
      end

    when 3
      clear
      titleize(" EDIT FLASHCARD ")

      selected_flashcards = get_flashcards_for_category(current_user)
      print_selected_flashcards(selected_flashcards)

      if selected_flashcards.size == 0
        next
      end

      card_to_edit = get_user_input("Please enter the number of the flashcard you'd like to edit").to_i

      new_flashcard = get_new_flashcard_info(current_user)
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

      selected_flashcards = get_flashcards_for_category(current_user)
      print_selected_flashcards(selected_flashcards)

      card_to_edit = get_user_input("Please enter the number of the flashcard you'd like to delete. (Or type 'exit')").to_i
      if card_to_edit == 0
        next
      else
        selected_flashcards[card_to_edit-1].destroy
        puts "Your card has been successfully deleted."
      end

    when 5
      clear
      titleize(" CREATE A NEW CATEGORY ")
      create_new_category(current_user)

    when 6
      clear
      titleize(" VIEW CARDS BY CATEGORY ")

      selected_flashcards = get_flashcards_for_category(current_user)
      if selected_flashcards != nil
        print_selected_flashcards(selected_flashcards)
      else
        next
      end

    when 7
      clear
      titleize(" TEST YOURSELF ")

      resume_or_start_over = get_user_input("To resume from last test, type 'resume'\nTo start new test, type 'new'")

      if resume_or_start_over == "new"

        print_all_categories(current_user)
        category_to_view = get_user_input("For which category would you like to test yourself? (Type exit at any time)").downcase.capitalize
        if category_to_view == "Exit"
          next
        end

        selected_category = current_user.categories.find_by(name:category_to_view)
        if selected_category == nil
          puts "That category does not exist. Please try again."
          next
        end

        selected_category.activate

        unselected_categories = current_user.categories.where.not(name:category_to_view)
        unselected_categories.all.each do |unselected_category|
          unselected_category.set_status_to(false)
        end

        flashcards_in_category = Flashcard.where(category_id:selected_category.id)
        flashcards_in_category.each do |card|
          card.reset
        end

      elsif resume_or_start_over == "resume"
        selected_category = current_user.categories.find_by(active_test:true)

        if selected_category == nil
          puts "You have no test to resume"
          next
        end

        puts "You are resuming the #{selected_category.name.upcase} category."
        flashcards_in_category = Flashcard.where(category_id:selected_category.id)

      else
        puts "That is an invalid choice"
        next
      end

      test_status = ""

      while selected_category.score < flashcards_in_category.size && test_status != "break"
        flashcards_in_category.each do |card|
          if card.status != "Correct"

            user_answer = get_user_input("\n#{card.front}\nProvide your answer:")

            if user_answer == "exit"
              test_status = "break"
              break

            elsif user_answer.downcase == card.back.downcase
              card.user_answer = user_answer
              puts "CORRECT!!"
              card.status = "Correct"
              card.save

              selected_category.score += 1
              selected_category.save

            else
              card.user_answer = user_answer
              puts "INCORRECT"
              card.status = "Incorrect"
              card.save
            end
          end
        end
      end

      puts "\nYou are done with the #{selected_category.name.capitalize} test! Your current score is #{selected_category.score} out of #{flashcards_in_category.size}."
      puts "Your grade is #{((selected_category.score.to_f/flashcards_in_category.size)*100).round}%"

    when 8
      clear
      titleize(" VIEW SCORE/RECENT ANSWERS ")

      print_all_categories(current_user)
      selected_category = current_user.categories.find_by(name:get_user_input("\nChoose a category.").downcase.capitalize)
      selected_flashcards = Flashcard.where(category_id:selected_category.id)


      if selected_flashcards.size == 0
        puts "\nThere are no flashcards in this category.\nLast score: n/a. Grade: n/a  "
      else
        puts "\nLast score: #{selected_category.score} out of #{selected_flashcards.size}. Grade: #{((selected_category.score.to_f/selected_flashcards.size)*100).round}%."
        puts "Recent answers"
        puts "------------------------------------------------"
        selected_flashcards.all.each do |flashcard|
          puts "\nQUESTION: #{flashcard.front}"
          puts "YOUR LAST ANSWER: #{flashcard.user_answer}"
          puts "STATUS: #{flashcard.status}"
        end
      end

    when 9
      clear
      titleize(" LOGGED OUT ")
      user_logged_in = false

    when 10
      clear
      titleize(" EXITED ")
      break


    end

  else
    login_or_signup = get_user_input("1. Login\n2. Create new user account").to_i

    if login_or_signup == 1
      username = get_user_input("Please enter your username")
      password = get_user_input("Please enter your password")
      logged_in = false
      User.all.each do |user|
        if user.username.downcase == username.downcase && user.password.downcase == password.downcase
          logged_in = true
          current_user = user
          clear
          puts "Welcome #{current_user}, your last login was at #{current_user.last_login}\n"
          # current_time = Time.now
          current_user.last_login = Time.now + Time.zone_offset('EST')
          current_user.save
          user_logged_in = true
        end
      end
      if !logged_in
        puts "Your username and password were incorrect. Please try again."
      end
    else login_or_signup == 2
      username = get_user_input("Please create a username")
      password = get_user_input("Please create a password")
      email = get_user_input("Please enter your email address")
      current_user = User.new(username:username, password:password, email:email, last_login:Time.now.localtime)
      if current_user.valid?
        current_user.save
        user_logged_in = true
      else
        puts current_user.errors.full_messages
      end
    end

  end
end
