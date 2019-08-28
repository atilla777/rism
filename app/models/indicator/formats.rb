# frozen_string_literal: true

module Indicator::Formats
  ESCAPED_FORMATS = %w[network network_service email_adress domain uri].freeze

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

  EMAIL_REGEXP = /[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+/.freeze

  DOMAIN_REGEXP = /(((?!-))(xn--|_{1,1})?[a-z0-9-]{0,61}[a-z0-9]{1,1}\.)*(xn--)?([a-z0-9\-]{1,61}|[a-z0-9-]{1,30}\.[a-z]{2,})/.freeze

  CONTEXTS_REGEXP= /(?:\((?<contexts>.{1,500})\))?/.freeze

  CONTENT_FORMATS = [
    {
      format: :filename,
      pattern: /^\s*filename#{CONTEXTS_REGEXP}:\s*(?<content>.{1,500})$/,
      check_prefix: true
    },
    {
      format: :filesize,
      pattern: /^\s*filesize#{CONTEXTS_REGEXP}:\s*(?<content>.{1,500})$/,
      check_prefix: true
    },
    {
      format: :process,
      pattern: /^\s*process#{CONTEXTS_REGEXP}:\s*(?<content>.{1,500})$/,
      check_prefix: true
    },
    {
      format: :account,
      pattern: /^\s*account#{CONTEXTS_REGEXP}:\s*(?<content>.{1,500})$/,
      check_prefix: true
    },
    {
      format: :email_theme,
      pattern: /^\s*email_theme#{CONTEXTS_REGEXP}:\s*(?<content>.{1,500})$/,
      check_prefix: true
    },
    {
      format: :email_content,
      pattern: /^\s*email_content#{CONTEXTS_REGEXP}:\s*(?<content>.{1,500})$/,
      check_prefix: true
    },
    {
      format: :uri,
      pattern: /\s*uri#{CONTEXTS_REGEXP}:\s*(?<content>#{URI.regexp})/,
      check_prefix: true
    },
    {
      format: :domain,
      pattern: /^\s*domain#{CONTEXTS_REGEXP}:\s*(?<content>#{DOMAIN_REGEXP})$/,
      check_prefix: true
      },
    {
      format: :email_author,
      pattern: /^\s*email_author#{CONTEXTS_REGEXP}:\s*(?<content>.{1,500})$/,
      check_prefix: true
    },
    {
      format: :registry,
      pattern: /^\s*registry#{CONTEXTS_REGEXP}:\s*(?<content>.{1,500})$/,
      check_prefix: true
    },
    {
      format: :other,
      pattern: /^\s*other#{CONTEXTS_REGEXP}:\s*(?<content>.{1,500})$/,
      check_prefix: true
    },
    {
      format: :network_service,
      pattern: /^\s*(#{CONTEXTS_REGEXP}:)?\s*(?<content>#{IP4_REGEXP}:#{NETWORK_PORT_REGEXP}(:tcp|:udp)?)\s*$/
    },
    {
      format: :network,
      pattern: /\s*(#{CONTEXTS_REGEXP}:)?\s*(?<content>#{IP4_REGEXP})\s*/
    },
    {
      format: :network_port,
      pattern: /^\s*(#{CONTEXTS_REGEXP}:)?\s*(?<content>#{NETWORK_PORT_REGEXP}(tcp|udp)?)\s*$/
    },
    {
      format: :email_adress, # TOD: fix adress to address
      pattern: /\s*(#{CONTEXTS_REGEXP}:)?\s*(?<content>#{EMAIL_REGEXP})\s*/i
    },
    {
      format: :md5,
      pattern: /\s*(#{CONTEXTS_REGEXP}:)?\s*\b(?<content>[a-f0-9]{32})\b/i
    },
    {
      format: :sha1,
      pattern: /\s*(#{CONTEXTS_REGEXP}:)?\s*\b(?<content>[a-f0-9]{40})\b/i
    },
    {
      format: :sha256,
      pattern: /\s*(#{CONTEXTS_REGEXP}:)?\s*\b(?<content>[a-f0-9]{64})\b/i
    },
    {
      format: :sha512,
      pattern: /\s*(#{CONTEXTS_REGEXP}:)?\s*\b(?<content>[a-f0-9]{128})\b/i
    }
  ]
end
