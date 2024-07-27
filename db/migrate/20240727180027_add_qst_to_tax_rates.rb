class AddQstToTaxRates < ActiveRecord::Migration[7.1]
  def change
    add_column :tax_rates, :qst, :decimal
  end
end
