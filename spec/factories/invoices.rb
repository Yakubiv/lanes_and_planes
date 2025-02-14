FactoryBot.define do
  factory :invoice do
    pdf { ActiveStorage::Blob.create_and_upload!(
            io: Rails.root.join('spec/fixtures/invoice.pdf').open,
            filename: 'bob_resume.pdf',
            content_type: 'application/pdf'
          ).signed_id }
  end
end
