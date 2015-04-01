require_relative '../lib/Flashcard'
require_relative '../lib/category'
require_relative '../app'
require 'active_record'


describe 'Flashcard objects' do
  it "should have questions and answers" do
    expect(Flashcard.first.front.class).to eq(String)
    expect(Flashcard.first.back.class).to eq(String)
  end
end

describe 'Category objects' do
  it "should have a name" do
    expect(Category.last.name.class).to eq(String)
    expect(Category.last.name.class).to eq(String)
  end
end

# describe '#print_menu' do
#   it "should print an interactive menu" do
#     expect(print_menu).to eq(nil)
#   end
# end
#
# describe '#print_all_flashcards' do
#   it "should print all of the flashcards" do
#     expect(print_all_flashcards(Flashcard.all)).to eq(nil)
#   end
# end
#
# describe '#print_all_categories' do
#   it "should print all of the categories" do
#     expect(print_all_categories).to eq(nil)
#   end
# end
#
# describe '#get_new_flash_info' do
#   it "should return a hash with the info for a new flashcard" do
#     expect(get_new_flash_info.class).to eq(Hash)
#   end
# end
#
# describe '#create_new_flashcard' do
#   it "should return a new Flashcard object" do
#     expect(create_new_flashcard.class).to eq(Flashcard)
#   end
# end
#
# describe '#get_category_from_user' do
#   it "should return the string object that the user entered" do
#     expect(get_category_from_user.class).to eq(String)
#   end
# # end
#
# describe '#get_new_category_info' do
#   it "should return a hash with the info for a new category" do
#     expect(get_new_category_info.class).to eq(Hash)
#   end
# end
#
# describe '#create_new_category' do
#   it "should return a new Category object" do
#     expect(create_new_category.class).to eq(Category)
#   end
# end

describe '#print_flashcards_for_category' do
    it "should return an array of flashcards" do
      selected_flashcards = print_flashcards_for_category
      expect(selected_flashcards[0].class).to eq(Flashcard)
    end
end
