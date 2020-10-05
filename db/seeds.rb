# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# Create admin, his organization and global roles (admin, editor, reader):
organization = Organization.new(name: I18n.t('labels.default_organization_name'))
organization.save(validate: false)

admin = User.new(name: I18n.t('roles.admin'),
            email: 'admin@rism.io',
            password: 'Pa$$w0rd',
            password_confirmation: 'Pa$$w0rd',
            organization_id: organization.id,
            active: true)
admin.save(validate: false)

admin_role = Role.create(name: I18n.t('roles.admin'))
Role.create(name: I18n.t('roles.editor'))
Role.create(name: I18n.t('roles.reader'))

RoleMember.create(user_id: admin.id, role_id: admin_role.id)

indocator_contexts = [
  {name: 'Source', codename: 'src', indicators_formats: %i[
    network_service
    network_port
    network
    email_adress
    uri
    domain
    process
    account
    other
    ]
  },
  {name: 'Destination', codename: 'dst', indicators_formats: %i[
    network_service
    network_port
    network
    email_adress
    uri
    domain
    process
    account
    other
    ]
  },
  {name: 'Relay', codename: 'relay', indicators_formats: %i[
    network_service
    network_port
    network
    other
    ]
  },
  {name: 'Attacker', codename: 'attacker', indicators_formats: %i[
    network_service
    network_port
    network
    email_adress
    uri
    domain
    account
    other
    ]
  },
  {name: 'Victim', codename: 'victim', indicators_formats: %i[
    network_service
    network_port
    network
    email_adress
    uri
    domain
    account
    other
    ]
  },
  {name: 'Compromised', codename: 'compromised', indicators_formats: %i[
    network_service
    network_port
    network
    email_adress
    uri
    domain
    account
    other
    ]
  },
  {name: 'Replay to', codename: 'replay_to', indicators_formats: %i[
    email_adress
    other
    ]
  },
  {name: 'Fake', codename: 'fake', indicators_formats: %i[
    network_service
    network_port
    network
    email_adress
    uri
    domain
    md5MD5
    sha256
    sha512
    email_theme
    email_content
    email_author
    filename
    filesize
    process
    account
    other
    ]
  },
  {name: 'Detected', codename: 'detected', indicators_formats: %i[
    network_service
    network_port
    network
    email_adress
    uri
    domain
    md5MD5
    sha256
    sha512
    email_theme
    email_content
    email_author
    filename
    filesize
    process
    account
    other
    ]
  },
  {name: 'Malware', codename: 'malware', indicators_formats: %i[
    md5MD5
    sha256
    sha512
    filename
    filesize
    process
    other
    ]
  },
  {name: 'Attachment', codename: 'att', indicators_formats: %i[
    md5MD5
    sha256
    sha512
    filename
    filesize
    process
    other
    ]
  },
  {name: 'Byte', codename: 'b', indicators_formats: %i[
    filesize
    other
    ]
  },
  {name: 'Kilobyte', codename: 'Kb', indicators_formats: %i[
    filesize
    other
    ]
  },
  {name: 'Megabyte', codename: 'Mb', indicators_formats: %i[
    filesize
    other
    ]
  },
  {name: 'Gigabyte', codename: 'Gb', indicators_formats: %i[
    filesize
    other
    ]
  }
]
 indocator_contexts.each do |context|
   IndicatorContext.create(context)
 end
