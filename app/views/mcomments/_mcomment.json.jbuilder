json.extract! mcomment, :id, :project_id, :user_id, :content, :created_at, :updated_at
json.url mcomment_url(mcomment, format: :json)
