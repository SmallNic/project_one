require 'active_record'

class Flashcard < ActiveRecord::Base
  belongs_to :category

  def to_s
    "QUESTION: #{front} \n|ANSWER: #{back}"

  end
end
