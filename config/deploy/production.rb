set :stage, :production

server 'rscz.ru', user: 'musicum', roles: %w{web app db}

set :rails_env, 'production'
set :unicorn_env, 'production'
set :unicorn_rack_env, 'production'
