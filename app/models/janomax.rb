class Janomax < ApplicationRecord
 has_paper_trail

  has_many :jmcustomer_items
  has_many :jmcustomers, through: :jmcustomer_items

 validates :item_name, presence: true, uniqueness: true

  after_update :notify_price_change

  private

  def notify_price_change
    if saved_change_to_selling_price?
      old_price, new_price = saved_change_to_selling_price

      Noticeboard.create(
        title: "Price updated",
        content: "#{item_name} price changed from KES #{old_price} → KES #{new_price}",
        notice_type: "price_change",
        status: true
      )
    end
  end


  after_create :notify_new_product

def notify_new_product
  Noticeboard.create(
    title: "New Product Added",
    content: "#{item_name} is now available at KES #{selling_price}",
    notice_type: "new_product",
    status: true
  )
end


  validates :item_name, presence: true, unless: -> { is_importing }
  # Whitelist the attributes you want searchable via Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[item_name item_description pieces sample]
  end

  # If you don't need any associations searchable (for now), return an empty array
  def self.ransackable_associations(auth_object = nil)
    []
  end

  mount_uploader :sample, ImageUploader

def self.import(file, skip_blanks: true)
  allowed_attributes = ["item_name", "selling_price", "item_description", "pieces"]

  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)

  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]

    # Skip blank rows by checking for required attributes
    next if skip_blanks && row["item_name"].blank?

    # Find the record by polling_station_code, or initialize a new one if not found
    ticket = Janomax.find_or_initialize_by(item_name: row["item_name"])

    # Skip this row if the record already exists to avoid duplicates
    # If you want to update existing records, remove this check
    if ticket.persisted?
      puts "Janomax Premium bale #{row["item_name"]} already exists. Skipping..."
      next
    end

    # Assign attributes and save
    ticket.attributes = row.to_hash.slice(*allowed_attributes)
    ticket.is_importing = true
    ticket.save!
  end
end

   


def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
   when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
   when '.xls' then Roo::Excel.new(file.path )
   when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
   else raise "Unknown file type: #{file.original_filename}"
  end
end


end
