json.array!(@feedbacks) do |feedback|
  json.extract! feedback, 
  json.url feedback_url(feedback, format: :json)
end
