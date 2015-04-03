class Category < ActiveRecord::Base
  has_many :flashcards, dependent: :destroy
  belongs_to :user

  validates :name, uniqueness: {message: "must be already exists. Try again."}
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

  def set_status_to(status)
    self.active_test = status
    self.save
  end

  def activate
    self.set_status_to(true)
    self.score = 0
    self.save
  end


end
