class CopyProvinceDataFromTaxRates < ActiveRecord::Migration[6.0]
  def up
    TaxRate.select(:province).distinct.each do |tax_rate|
      Province.create(name: tax_rate.province)
    end
  end

  def down
    Province.delete_all
  end
end
