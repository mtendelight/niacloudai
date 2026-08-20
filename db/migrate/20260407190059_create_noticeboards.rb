class CreateNoticeboards < ActiveRecord::Migration[8.1]
  def change
    create_table :noticeboards do |t|
      t.string :title
      t.text :content
      t.string :notice_type
      t.boolean :status

      t.timestamps
    end
  end
end
