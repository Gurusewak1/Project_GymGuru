# This file seeds the database with required data

if Rails.env.development?
  AdminUser.find_or_create_by!(email: "admin@example.com") do |admin|
    admin.password = "password"
    admin.password_confirmation = "password"
  end
end

# ---------------------------
# Provinces + Tax Rates
# ---------------------------

tax_data = [
  { name: "Alberta", gst: 5, pst: 0, hst: 0, qst: 0 },
  { name: "British Columbia", gst: 5, pst: 7, hst: 0, qst: 0 },
  { name: "Manitoba", gst: 5, pst: 7, hst: 0, qst: 0 },
  { name: "Saskatchewan", gst: 5, pst: 6, hst: 0, qst: 0 },
  { name: "Ontario", gst: 0, pst: 0, hst: 13, qst: 0 },
  { name: "Quebec", gst: 5, pst: 0, hst: 0, qst: 9.975 },
  { name: "Nova Scotia", gst: 0, pst: 0, hst: 15, qst: 0 },
  { name: "New Brunswick", gst: 0, pst: 0, hst: 15, qst: 0 },
  { name: "Newfoundland and Labrador", gst: 0, pst: 0, hst: 15, qst: 0 },
  { name: "Prince Edward Island", gst: 0, pst: 0, hst: 15, qst: 0 },
  { name: "Northwest Territories", gst: 5, pst: 0, hst: 0, qst: 0 },
  { name: "Yukon", gst: 5, pst: 0, hst: 0, qst: 0 },
  { name: "Nunavut", gst: 5, pst: 0, hst: 0, qst: 0 }
]

tax_data.each do |data|
  province = Province.find_or_create_by(name: data[:name])

  TaxRate.find_or_create_by(province: province) do |t|
    t.gst = data[:gst]
    t.pst = data[:pst]
    t.hst = data[:hst]
    t.qst = data[:qst]
  end
end