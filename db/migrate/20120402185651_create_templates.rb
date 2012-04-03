class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string     :name
      t.string     :template_type
      t.text       :content
      t.references :oauth_client

      t.timestamps
    end
  end
end
