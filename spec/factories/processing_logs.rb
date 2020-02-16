FactoryBot.define do
  factory :processing_log do
    processed false
    delivery_subject nil
    processed_by nil
    processor_comment "MyString"
  end
end
