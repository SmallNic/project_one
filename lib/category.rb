class Category < ActiveRecord::Base
  has_many :flashcards, dependent: :destroy

  validates :name, uniqueness: {message: "must be unique"}
  validates :name, presence: {message: "must be entered"}

  def to_s
    name
  end

end
