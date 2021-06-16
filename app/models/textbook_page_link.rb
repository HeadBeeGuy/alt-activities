class TextbookPageLink < ApplicationRecord
  belongs_to :activity
  belongs_to :textbook_page
end
