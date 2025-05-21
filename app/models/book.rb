class Book < ApplicationRecord
    has_many :reading_progresses, dependent: :destroy
end
