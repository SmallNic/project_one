require_relative 'connection'
require_relative '../lib/category'
require_relative '../lib/flashcard'

Category.destroy_all
Flashcard.destroy_all

Category.create([
  {name: "Movies", score:0, active_test: false},
  {name: "Music", score:0, active_test: false},
  {name: "Literature", score:0, active_test: false},
  {name: "History", score:0, active_test: false}
  ])

movies = Category.find_by(name: "Movies")
music = Category.find_by(name: "Music")
literature = Category.find_by(name: "Literature")
history = Category.find_by(name: "History")


movies.flashcards.create ([
  {front:"Quentin Tarantino made disturbing use of the song, 'Stuck in the Middle with You' in what movie?", back:"Reservoir Dogs", status:"unanswered", user_answer:nil},
  {front:"Who voiced the character V in V for Vendetta", back:"Hugo Weaving", status:"unanswered", user_answer:nil},
  {front:"In what movie did George Carlin help a musical duo save the future?", back:"Bill and Ted's Excellent Adventure", status:"", user_answer:nil}
  ])

music.flashcards.create ([
  {front:"What is the name of Michael Jackson's 1988 anthology film?", back:"Moonwalker", status:"unanswered", user_answer:nil},
  {front:"How old was Mozart when he wrote his first peace?", back:"Five", status:"unanswered", user_answer:nil},
  {front:"Garth Brooks took on this alter ego 1999.", back:"Chris Gaines", status:"unanswered", user_answer:nil}
  ])

literature.flashcards.create ([
  {front:"In the Hitchhiker's Guide to the Galaxy, what is the ultimate answer to life, the universe and everything?", back:"42", status:"unanswered", user_answer:nil},
  {front:"Was 7 part Dark Tower series written by Dean Koontz or Stephen King?", back:"Stephen King", status:"unanswered", user_answer:nil},
  {front:"Who is the main character of Bret Easton Ellis's American Psycho?", back:"Patrick Bateman", status:"unanswered", user_answer:nil}
  ])

history.flashcards.create ([
  {front:"What part of a knight's body did the greaves cover?", back:"Shins", status:"", user_answer:nil},
  {front:"What ancient South American people considered llamas sacred?", back:"Inca", status:"unanswered", user_answer:nil},
  {front:"What country had the first hospital in North America?", back:"Mexico", status:"unanswered", user_answer:nil}
  ])
