# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# Create admin, his organization and global roles (admin, editor, reader):
organization = Organization.new(name: 'Default organization')
organization.save(validate: false)

admin = User.new(name: I18n.t('roles.admin'),
            email: 'admin@rism.io',
            password: 'password',
            password_confirmation: 'password',
            organization_id: organization.id,
            active: true)
admin.save(validate: false)

admin_role = Role.create(name: I18n.t('roles.admin'))
Role.create(name: I18n.t('roles.editor'))
Role.create(name: I18n.t('roles.reader'))

RoleMember.create(user_id: admin.id, role_id: admin_role.id)
