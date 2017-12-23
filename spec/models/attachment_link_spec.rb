require 'rails_helper'

RSpec.describe AttachmentLink do
  it { should validate_presence_of(:record_type) }
  it { should validate_numericality_of(:record_id)
       .only_integer }
  it { should validate_numericality_of(:attachment_id)
       .only_integer }
  it { should belong_to(:attachment) }
  it { should belong_to(:record) }

  context 'when destroy and it is last link to attachment' do
    it 'destroy attachment' do
      agreement = create(:agreement)
      attachment = create(:attachment)
      attachment_link = create(:attachment_link,
                               record_type: 'Agreement',
                               record_id: agreement.id,
                               attachment_id: attachment.id)
      attachment_link.destroy

      expect(Attachment.where(id: attachment.id).first).not_to be
    end
  end

  context 'when destroy and it is not last link to attachment' do
    it 'don`t destroy attachment' do
      agreement1 = create(:agreement)
      agreement2 = create(:agreement)
      attachment = create(:attachment)
      attachment_link1 = create(:attachment_link,
                               record_type: 'Agreement',
                               record_id: agreement1.id,
                               attachment_id: attachment.id)
      create(:attachment_link,
             record_type: 'Agreement',
             record_id: agreement2.id,
             attachment_id: attachment.id)
      attachment_link1.destroy

      expect(Attachment.where(id: attachment.id).first).to be
    end
  end
end
