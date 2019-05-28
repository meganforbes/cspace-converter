module ApplicationHelper

  def batches
    [ "all" ].concat( DataObject.pluck('import_batch').uniq )
  end

  def collectionspace_base_uri
    Rails.application.secrets[:collectionspace_base_uri]
  end

  def collectionspace_domain
    Rails.application.config.domain
  end

  def collectionspace_username
    Rails.application.secrets[:collectionspace_username]
  end

  def modules
    CollectionSpace::Converter.constants.find_all do |c|
      "CollectionSpace::Converter::#{c}".constantize.respond_to? :registered_profiles
    end.sort
  end

  def profiles
    profiles = []
    modules.each do |c|
      converter = "CollectionSpace::Converter::#{c}".constantize
      converter.registered_profiles.keys.sort.each do |profile|
        profiles << [profile, profile, class: c.to_s]
      end
    end
    profiles
  end

  def types
    CollectionSpaceObject.pluck('type').uniq
  end

  def short_date(date)
    date.to_s(:short)
  end

end
