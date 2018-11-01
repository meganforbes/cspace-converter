Dir["#{Rails.root.join('lib', 'collectionspace')}/**/*.rb"].each do |lib|
  require lib
end
