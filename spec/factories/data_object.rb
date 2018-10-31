FactoryGirl.define do

  factory :data_object do
    import_file 'ppsobjectsdata.csv'
    import_batch 'ppbatch1'
    converter_module 'PastPerfect'
    converter_profile 'ppsobjectsdata'
    sequence(:objectid) { |n| "2000.#{n}" }
  end

end
