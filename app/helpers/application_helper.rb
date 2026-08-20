module ApplicationHelper

  def total_unread_messages(user)
  Message.where(read: false)
         .where(conversation_id: user.conversations.select(:id))
         .where.not(user_id: user.id)
         .count
end



def mask_phone(phone)
  return "" if phone.blank?

  phone = phone.to_s

  if phone.length >= 12
    "#{phone[0..5]}XXX#{phone[-3..]}"
  else
    phone
  end
end

  attr_accessor :is_importing

  def default_meta_tags
    {
      site: 'Live',
      title: 'Soccerstar',
      reverse: true,
      separator: '|',
      description: 'Your home for the Football Sport airing live schedule as well as store for best highlights.',
      keywords: 'soccer, soccerstar, football, highlights, scheduled, games',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url('logo3.png') },
        { href: image_url('logo3.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: 'Live',
        title: 'SoccerStar',
        description: 'Your home for the Football Sport airing live schedule as well as store for best highlights.', 
        type: 'website',
        url: request.original_url,
        image: image_url('logo3.png')
      }
    }
  end



  def link_to_add_fields(name, form, association)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end



   def stock_class(menu_item)
  case menu_item.stock
  when 2...5
    'table-warning font-weight-bold'
  when -Float::INFINITY..1
    'table-danger font-weight-bold'
  else
    'table-success font-weight-bold'
  end
end



 def row_class_for_state(kitchen_status_id) 
   case kitchen_status_id 
   when 'Pending' 
    'table-danger font-weight-bold' # For pending orders
   when 'In progress' 
    'table-warning font-weight-bold' # For in-progress orders
   when 'Ready' 
    'table-success font-weight-bold' # For ready orders
   when 'Delivered' 
    'table-secondary font-weight-bold' # For completed/delivered orders
   else 
    'table-dark font-weight-bold' # Default class for unrecognized statuses
   end 
 end 

end
