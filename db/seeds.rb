# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

tasks = [
  { title: 'Learn Ruby on Rails', completed: false },
  { title: 'Build an API', completed: false }
]

tasks.each do |attrs|
  Task.find_or_create_by!(title: attrs[:title]) do |task|
    task.completed = attrs[:completed]
  end
end

puts "Seeded #{Task.count} tasks"
