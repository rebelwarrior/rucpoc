FactoryGirl.define do
  factory :collection do
    sequence(:internal_id_number) { |n| "12345#{n}"}
    debtor_id 2
    amount_owed 2_000.00 
  end
end