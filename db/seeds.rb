# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# first_user = User.new(first_name: 'todd', last_name: 'willey',
#                       password: 'mypassw0rd',
#                       password_confirmation: 'mypassw0rd',
#                       email: 'todd.willey@notmyrealhost.com')
# #first_user.skip_confirmation!
# first_user.save!
# first_user.add_role 'super_admin'
# first_user.add_role 'chruch_admin'
# first_user.add_role 'need_poster'

# Need.create!(
#   title: 'Test Need',
#   title_public: 'Test Need',
#   description: 'Just another need',
#   description_public: 'Just another need',
#   user_id_posted_by: first_user.id,
#   user_id_church_admin: first_user.id,
#   need_stage: 'admin_in_progress',
#   is_public: true)


Skill.create!(
  name: 'Skill 1',
  description: 'This is a skill.',
  icon_url: 'https://s3.amazonaws.com/church_of/assets/skill_icons/726-star%402x.png?AWSAccessKeyId=ASIAILF7YYCQXNY2GFOA&Expires=1394246290&Signature=F4wNTVSpCCNEVGxhXC%2B4Drtmo/k%3D&x-amz-security-token=AQoDYXdzEIP//////////wEakAKbZx6itNHYwi46/u4xJDj4dosHBapQvf0nX/cADKULVxWefEzg/364vO9stlQjMCKloJRs3jYp6jYqPyki4a2eAGWNUdoAKempFN/h%2B9m3MVeUWzz/JGuf64IzHbd7eU1QRVWonT/nCORawnf34wTRyTnZfpGcV9F0weccgMbOLHND5wDMHTbz7Lb0%2ByzV%2Bf1IBa6VSdosQ94iTOsdysfs2Y8F7t%2B7iCopwaOd9gN8vrHNxD5T/A8J4lhmhxtOIBIvgUmsy%2BIEVhjIdfuNfHx8w4bcv1WdvfoVNqnzWwUAAB8UlfWpdISuWX4prQ2dfhVSLe7btxm82fScJR%2Bnp7P%2B2daYUZ89dtoR4BSHVOZ%2BjyDC8umYBQ%3D%3D')

Skill.create!(
  name: 'Skill 2',
  description: 'This is a skill.',
  icon_url: 'https://s3.amazonaws.com/church_of/assets/skill_icons/726-star%402x.png?AWSAccessKeyId=ASIAILF7YYCQXNY2GFOA&Expires=1394246290&Signature=F4wNTVSpCCNEVGxhXC%2B4Drtmo/k%3D&x-amz-security-token=AQoDYXdzEIP//////////wEakAKbZx6itNHYwi46/u4xJDj4dosHBapQvf0nX/cADKULVxWefEzg/364vO9stlQjMCKloJRs3jYp6jYqPyki4a2eAGWNUdoAKempFN/h%2B9m3MVeUWzz/JGuf64IzHbd7eU1QRVWonT/nCORawnf34wTRyTnZfpGcV9F0weccgMbOLHND5wDMHTbz7Lb0%2ByzV%2Bf1IBa6VSdosQ94iTOsdysfs2Y8F7t%2B7iCopwaOd9gN8vrHNxD5T/A8J4lhmhxtOIBIvgUmsy%2BIEVhjIdfuNfHx8w4bcv1WdvfoVNqnzWwUAAB8UlfWpdISuWX4prQ2dfhVSLe7btxm82fScJR%2Bnp7P%2B2daYUZ89dtoR4BSHVOZ%2BjyDC8umYBQ%3D%3D')

Skill.create!(
  name: 'Skill 3',
  description: 'This is a skill.',
  icon_url: 'https://s3.amazonaws.com/church_of/assets/skill_icons/726-star%402x.png?AWSAccessKeyId=ASIAILF7YYCQXNY2GFOA&Expires=1394246290&Signature=F4wNTVSpCCNEVGxhXC%2B4Drtmo/k%3D&x-amz-security-token=AQoDYXdzEIP//////////wEakAKbZx6itNHYwi46/u4xJDj4dosHBapQvf0nX/cADKULVxWefEzg/364vO9stlQjMCKloJRs3jYp6jYqPyki4a2eAGWNUdoAKempFN/h%2B9m3MVeUWzz/JGuf64IzHbd7eU1QRVWonT/nCORawnf34wTRyTnZfpGcV9F0weccgMbOLHND5wDMHTbz7Lb0%2ByzV%2Bf1IBa6VSdosQ94iTOsdysfs2Y8F7t%2B7iCopwaOd9gN8vrHNxD5T/A8J4lhmhxtOIBIvgUmsy%2BIEVhjIdfuNfHx8w4bcv1WdvfoVNqnzWwUAAB8UlfWpdISuWX4prQ2dfhVSLe7btxm82fScJR%2Bnp7P%2B2daYUZ89dtoR4BSHVOZ%2BjyDC8umYBQ%3D%3D')