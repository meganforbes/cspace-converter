# 1st require the DEFAULT module
Dir["#{Rails.root.join('lib', 'collectionspace', 'converter', 'default')}/*.rb"].each do |lib|
  require lib
end

# then require everything else
Dir["#{Rails.root.join('lib', 'collectionspace')}/**/*.rb"].each do |lib|
  require lib
end
