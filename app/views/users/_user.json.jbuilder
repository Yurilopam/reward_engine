json.extract! user, :id, :total_score, :login_streak, :last_login_date, :created_at, :updated_at
json.url user_url(user, format: :json)
