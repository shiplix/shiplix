json.message smell.message
json.icon smell.class.icon
json.line smell.position.first
json.num_lines smell.position.count

if smell.data.present?
  json.data smell.data
end
