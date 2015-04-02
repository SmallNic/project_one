require 'active_record'

class Flashcard < ActiveRecord::Base
  belongs_to :category

  # validates :category_id, presence: {message: "does not exist. Try again"}
  validates :front, presence: {message: "must be provided."}, uniqueness: {message: "already exists. Try again."}
  validates :back, presence: {message: "must be provided."}
  # validates :status, presence: {message: "must be provided."}

  def to_s
    # question_size = "QUESTION: ".size + front.size
    # answer_size = "ANSWER: ".size + back.size
    # question_spaces = " " * (terminal_size()[0] - question_size - 1)
    # answer_spaces = " " * (terminal_size()[0] - answer_size - 1)
    top_border = "_" * terminal_size()[0]
    content = "|QUESTION: #{front} \n|ANSWER: #{back}"
    bottom_border = "-" * terminal_size()[0]
    return top_border + "\n" + content + "\n" + bottom_border
    # return "QUESTION: #{front}" + question_spaces + "|\n" + "|ANSWER: #{back}" + question_spaces + "|"
  end


  HUMANIZED_ATTRIBUTES = {
     :front => "ERROR: Question",
     :back => "ERROR: Answer"
   }

   def self.human_attribute_name(attr, options={})
     HUMANIZED_ATTRIBUTES[attr.to_sym] || super
   end






  # def print_selection
  #   counter = 1
  #   self.all.each do |flashcard|
  #     puts "_" * terminal_size()[0]
  #     puts "#{counter}. #{self}"
  #     puts "-" * terminal_size()[0]
  #     counter += 1
  #   end
  #   if counter == 1
  #     puts "There are no flashcards to print."
  #   end
  # end
end
