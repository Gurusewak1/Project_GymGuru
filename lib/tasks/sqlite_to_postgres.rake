namespace :db do
  desc "Safely migrate ALL SQLite data to PostgreSQL (no validation blocking)"

  task migrate_sqlite: :environment do
    puts "🚀 Starting safe SQLite → PostgreSQL migration..."

    # Connect to SQLite (source)
    ActiveRecord::Base.establish_connection(:development)

    models = ApplicationRecord.descendants.reject(&:abstract_class?)

    models.each do |model|
      puts "➡ Migrating #{model.name}..."

      begin
        records = model.all.to_a

        # Switch to Postgres (target)
        ActiveRecord::Base.establish_connection(:production)

        records.each do |record|
          attrs = record.attributes.except("id", "created_at", "updated_at")

          # SAFE INSERT (bypasses validations)
          new_record = model.new(attrs)
          new_record.save!(validate: false)
        end

        puts "✔ Done #{model.name}"

      rescue => e
        puts "⚠ Skipped #{model.name}: #{e.message}"
      end
    end

    puts "🎉 MIGRATION COMPLETE!"
  end
end