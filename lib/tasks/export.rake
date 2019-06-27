namespace :export do
  # rake export:xml
  task :xml => :environment do |t|
    # mongoid batches by default
    base = ['db', 'data', 'export']
    CollectionSpaceObject.all.each do |obj|
      path = Rails.root.join(File.join(base + [obj.category, obj.type, obj.subtype].compact))
      FileUtils.mkdir_p File.join(path)
      file_path = path + "#{obj.identifier}.xml"
      Rails.logger.debug "Exporting: #{file_path}"
      File.open(file_path, 'w') {|f| f.write(obj.content) }
    end
  end
end
