namespace :db do
  task transfer_sqlite: :environment do
    puts "🚀 SAFE TRANSFER STARTING..."

    sqlite = ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: "storage/development.sqlite3"
    ).connection

    pg = ActiveRecord::Base.establish_connection(:development).connection

    tables = %w[users products orders categories admin_users tax_rates provinces]

    tables.each do |table|
      puts "➡ Migrating #{table}..."

      rows = sqlite.execute("SELECT * FROM #{table}")

      rows.each do |row|
        begin
          columns = row.keys
          values = row.values

          placeholders = (["?"] * columns.size).join(",")

          pg.execute("INSERT INTO #{table} (#{columns.join(',')}) VALUES (#{placeholders})", values)
        rescue => e
          puts "❌ Skipped row in #{table}: #{e.message}"
        end
      end

      puts "✔ Done #{table}"
    end

    puts "🎉 DONE — ALL DATA TRANSFERRED"
  end
end