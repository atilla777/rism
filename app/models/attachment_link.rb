class AttachmentLink < ApplicationRecord
  belongs_to :record, polymorphic: true
end
