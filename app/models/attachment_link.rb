class AttachmentLink < ApplicationRecord
  belongs_to :record, polymorphic: true
  belongs_to :attachment
end
