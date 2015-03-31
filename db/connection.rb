require 'active_record'

ActiveRecord::Base.establish_connection(
        database: 'flashcard_db',
        adapter: 'postgresql'
      )
