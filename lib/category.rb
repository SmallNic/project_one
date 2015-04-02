class Category < ActiveRecord::Base
  has_many :flashcards, dependent: :destroy

  validates :name, uniqueness: {message: "must be unique."}
  validates :name, presence: {message: "must be entered."}

  HUMANIZED_ATTRIBUTES = {
     :name => "ERROR: Category name"
   }

   def self.human_attribute_name(attr, options={})
     HUMANIZED_ATTRIBUTES[attr.to_sym] || super
   end


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
