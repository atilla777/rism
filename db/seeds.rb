# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
organization = Organization.new(name: 'Default organization', kind: 0)
organization.save(validate: false)
user = User.new(name: I18n.t('roles.admin'),
            email: 'admin@rism.io',
            password: 'password',
            password_confirmation: 'password',
            organization_id: organization.id,
            active: true)
user.save(validate: false)
role = Role.create(name: I18n.t('roles.admin'))
Role.create(name: I18n.t('roles.editor'))
Role.create(name: I18n.t('roles.reader'))
RoleMember.create(user_id: user.id, role_id: role.id)
