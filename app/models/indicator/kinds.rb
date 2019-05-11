# frozen_string_literal: true

module Indicator::Kinds

  NETWORK_PORT_REGEXP = /(6553[0-5]|655[0-2][0-9]\d|65[0-4](\d){2}|6[0-4](\d){3}|[1-5](\d){4}|[1-9](\d){0,3})/.freeze
  IP4_REGEXP = /((?x-mi:0
               |1(?:[0-9][0-9]?)?
               |2(?:[0-4][0-9]?|5[0-5]?|[6-9])?
               |[3-9][0-9]?))\.((?x-mi:0
               |1(?:[0-9][0-9]?)?
               |2(?:[0-4][0-9]?|5[0-5]?|[6-9])?
               |[3-9][0-9]?))\.((?x-mi:0
               |1(?:[0-9][0-9]?)?
               |2(?:[0-4][0-9]?|5[0-5]?|[6-9])?
               |[3-9][0-9]?))\.((?x-mi:0
               |1(?:[0-9][0-9]?)?
               |2(?:[0-4][0-9]?|5[0-5]?|[6-9])?
               |[3-9][0-9]?))/.freeze

  CONTENT_KINDS = [
    {kind: :other, pattern: /^\s*other:\s*(.{1,500})$/, check_prefix: true},
    {kind: :network_service, pattern: /^\s*(#{IP4_REGEXP}:#{NETWORK_PORT_REGEXP}:(tcp|udp)?)\s*$/},
    {kind: :network, pattern: /^\s*(#{IP4_REGEXP})\s*$/},
    {kind: :network_port, pattern: /^\s*(#{NETWORK_PORT_REGEXP}(tcp|udp)?)\s*$/},
    {kind: :email_adress, pattern: /^\s*([\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+)\s*$/i},
    {kind: :email_theme, pattern: /^\s*email_theme:\s*(.{1,500})$/, check_prefix: true},
    {kind: :email_content, pattern: /^\s*email_content:\s*(.{1,500})$/, check_prefix: true},
    {kind: :uri, pattern: /\s*uri:\s*(#{URI.regexp})/, check_prefix: true},
    {kind: :domain, pattern: /^\s*domain:\s*((((?!-))(xn--|_{1,1})?[a-z0-9-]{0,61}[a-z0-9]{1,1}\.)*(xn--)?([a-z0-9\-]{1,61}|[a-z0-9-]{1,30}\.[a-z]{2,}))$/, check_prefix: true},
    {kind: :md5, pattern: /^\s*([a-f0-9]{32})\s*$/i},
    {kind: :sha256, pattern: /^\s*([a-f0-9]{64})\s*$/i},
    {kind: :sha512, pattern: /^\s*([a-f0-9]{128})\s*$/i},
    {kind: :filename, pattern: /^\s*filename:\s*(.{1,500})$/, check_prefix: true},
    {kind: :filesize, pattern: /^\s*filesize:\s*(.{1,500})$/, check_prefix: true},
    {kind: :process, pattern: /^\s*process:\s*(.{1,500})$/, check_prefix: true},
    {kind: :account, pattern: /^\s*account:\s*(.{1,500})$/, check_prefix: true},
  ]

#  NETWORK = { network: [
#      :attac_source,
#      :attac_destination
#    ]
#  }
#
#  CONTENT_SUBKINDS = [
#    {kind: :network_service, subkinds: NETWORK},
#    {kind: :network, subkinds: NETWORK},
#    {kind: :network_port, subkinds: NETWORK},
#    {kind: :email_adress, pattern: /^\s*([\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+)\s*$/i, check_prefix: true},
#    {kind: :uri, subkinds: URI},
#    {kind: :domain, subkinds: DOMAIN},
#    {kind: :md5, subkinds: FILE},
#    {kind: :sha256, subkinds: FILE},
#    {kind: :sha512, subkinds: FILE},
#    {kind: :filename, subkinds: FILE},
#    {kind: :filesize, subkinds: FILE},
#    {kind: :process, subkinds: PROCESS},
#    {kind: :account, subkinds: ACCOUNT},
#  ]
end
