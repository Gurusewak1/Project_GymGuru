class AddProvinceIdToTaxRates < ActiveRecord::Migration[7.1]
  def change
    add_column :tax_rates, :province_id, :integer
  end
end
