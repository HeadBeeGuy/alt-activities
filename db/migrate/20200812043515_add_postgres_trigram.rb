# Add the PostgreSQL extension for trigrams
# This allows for some degree of "fuzzy" searching, but nothing too advanced.
# Origially I tried using the multisearch functionality of pg_search, but
# combining it with trigrams in a way that returned useful results was getting
# quite messy.
class AddPostgresTrigram < ActiveRecord::Migration[5.2]
  def up
    execute "create extension if not exists pg_trgm;"
  end

  def down
    execute "drop extension if exists pg_trgm;"
  end
end
