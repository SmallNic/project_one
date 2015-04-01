require 'active_record'

class Flashcard < ActiveRecord::Base
  belongs_to :category

  # validates :category_id, presence: {message: "must be provided."}
  # validates :front, presence: {message: "must be provided."}, uniqueness: {message: "must be unique."}
  # validates :back, presence: {message: "must be provided."}
  # validates :status, presence: {message: "must be provided."}

  def to_s
    "QUESTION: #{front} \nANSWER: #{back}"
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
