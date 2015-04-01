class Category < ActiveRecord::Base
  has_many :flashcards, dependent: :destroy

  validates :name, uniqueness: {message: "must be unique"}
  validates :name, presence: {message: "must be entered"}


  def to_s
    title = "-------------------Categories-------------------"
    spaces = " " * (title.size - name.size - 1)
    return name + spaces + "|"
    # name
  end

  # def print_all
  #   puts"-------------------Categories-------------------"
  #   puts Category.all
  #   puts"------------------------------------------------"
  # end

end
