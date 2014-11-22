namespace :classic_online do
  require "#{Rails.root}/extra/classic_online"
  desc "Parse items from classic-online.ru"
  task :parse => ['environment'] do
    t = ClassicOnline.new
    t.parse_bests
  end
end 
