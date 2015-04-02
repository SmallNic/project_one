require 'active_record'

class Flashcard < ActiveRecord::Base
  belongs_to :category

  validates :front, presence: {message: "must be provided."}, uniqueness: {message: "already exists. Try again."}
  validates :back, presence: {message: "must be provided."}

  def to_s
    top_border = "_" * terminal_size()[0]
    content = "|QUESTION: #{front} \n|ANSWER: #{back}"
    bottom_border = "-" * terminal_size()[0]
    return top_border + "\n" + content + "\n" + bottom_border
  end


  HUMANIZED_ATTRIBUTES = {
     :front => "ERROR: Question",
     :back => "ERROR: Answer"
   }

   def self.human_attribute_name(attr, options={})
     HUMANIZED_ATTRIBUTES[attr.to_sym] || super
   end

   def reset
     self.status = "Unanswered"
     self.user_answer = "n/a"
     self.save
   end

end
