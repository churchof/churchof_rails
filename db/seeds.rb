# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


first_user = User.new(first_name: 'todd', last_name: 'willey',
                      password: 'mypassw0rd',
                      password_confirmation: 'mypassw0rd',
                      email: 'todd.willey@notmyrealhost.com')
#first_user.skip_confirmation!
first_user.save!
first_user.add_role 'super_admin'
first_user.add_role 'chruch_admin'
first_user.add_role 'need_poster'

Need.create!(
  title: 'Test Need',
  title_public: 'Test Need',
  description: 'Just another need',
  description_public: 'Just another need',
  user_id_posted_by: first_user.id,
  user_id_church_admin: first_user.id,
  need_stage: 'admin_in_progress',
  is_public: true)
