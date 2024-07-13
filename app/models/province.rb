class Province < ApplicationRecord
  has_many :users
  has_many :tax_rates, foreign_key: :province, primary_key: :name

end
