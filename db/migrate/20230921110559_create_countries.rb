class CreateCountries < ActiveRecord::Migration[7.0]
  def up
    create_table :countries do |t|
      t.string :name, null: false
      t.string :alpha_2_code, limit: 2, null: false
      t.string :alpha_3_code, limit: 3, null: false
      t.string :currency, limit: 3, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE countries
      ADD CONSTRAINT check_alpha_2_code
      CHECK (alpha_2_code ~ '^[A-Z]{2}$');
    SQL

    execute <<-SQL
      ALTER TABLE countries
      ADD CONSTRAINT check_alpha_3_code
      CHECK (alpha_3_code ~ '^[A-Z]{3}$');
    SQL

    execute <<-SQL
      ALTER TABLE countries
      ADD CONSTRAINT check_currency
      CHECK (currency ~ '^[A-Z]{3}$');
    SQL

    add_index :countries, :alpha_2_code, unique: true
    add_index :countries, :alpha_3_code, unique: true
  end

  def down
    remove_index :countries, :alpha_2_code
    remove_index :countries, :alpha_3_code

    execute <<-SQL
      ALTER TABLE countries
      DROP CONSTRAINT IF EXISTS check_currency;
    SQL

    execute <<-SQL
      ALTER TABLE countries
      DROP CONSTRAINT IF EXISTS check_alpha_3_code;
    SQL

    execute <<-SQL
      ALTER TABLE countries
      DROP CONSTRAINT IF EXISTS check_alpha_2_code;
    SQL

    drop_table :countries
  end
end
