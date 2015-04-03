class User < ActiveRecord::Base
  has_many :categories, dependent: :destroy

  validates :username, uniqueness: {message: "must be already exists. Try again."}
  validates :password, presence: {message: "must be entered."}

  def to_s
    username
  end

end
