class Dl < Thor
  package_name "dl"
  include Thor::Actions

  no_commands do
    def load_env
      return if defined?(Rails)
      require File.expand_path("../../../config/environment", __FILE__)
    end

    def env_from
      'production'
    end
    def ssh_host
      'musicum.ru'
    end
    def ssh_user
      'musicum'
    end
    def ssh_opts
      {}
    end

    def remote_dump_path
      '/data/musicum/tmp_dump'
    end
    def remote_app_path
      "/data/musicum/app/current"
    end

    def local_auth(conf)
      if conf['password'].nil?
        ""
      else
        "-u #{conf["username"]} -p #{conf["password"]}]"
      end
    end
  end

  desc "download", "clone files and DB from production"
  def download
    load_env
    require 'net/ssh'

    puts "backup remote DB via ssh"
    r_conf = nil
    Net::SSH.start(ssh_host, ssh_user, ssh_opts) do |ssh|
      r_conf = YAML.load(ssh.exec!("cat #{remote_app_path}/config/mongoid.yml"))[env_from]['sessions']['default']
      puts ssh.exec!("rm -R #{remote_dump_path}")
      puts ssh.exec!("mkdir -p #{remote_dump_path}")
      dump = "mongodump -u #{r_conf['username']} -p #{r_conf['password']} -d #{r_conf['database']} --authenticationDatabase #{r_conf['database']} -o #{remote_dump_path}"
      puts dump
      puts ssh.exec!(dump)
    end
    conf = YAML.load_file(Rails.root.join('config', 'mongoid.yml'))[Rails.env]['sessions']['default']
    db_to = conf['database']
    db_path = Rails.root.join("tmp", "dmp", "dump", db_to).to_s
    `mkdir -p #{db_path}`
    rsync = "rsync -e ssh --progress -lzuogthvr #{ssh_user}@#{ssh_host}:#{remote_dump_path}/#{r_conf['database']}/ #{db_path}/"
    puts rsync
    pipe = IO.popen(rsync)
    while (line = pipe.gets)
      print line
    end

    puts "restoring DB"
    if Rails.env.staging?
      restore = "mongorestore --drop -d #{db_to} -u #{remote_db_user} -p #{remote_db_pass} --authenticationDatabase admin #{db_path}"
    else
      restore = "mongorestore --drop -d #{db_to} #{local_auth(conf)} #{db_path}"
    end
    puts restore
    pipe = IO.popen(restore)
    while (line = pipe.gets)
      print line
    end

    rsync = "rsync -e ssh --progress -lzuogthvr #{ssh_user}@#{ssh_host}:#{remote_app_path}/public/system/ #{Rails.root.join('public/system')}/"
    puts rsync
    pipe = IO.popen(rsync)
    while (line = pipe.gets)
      print line
    end

    rsync = "rsync -e ssh --progress -lzuogthvr #{ssh_user}@#{ssh_host}:#{remote_app_path}/public/ckeditor_assets/ #{Rails.root.join('public/ckeditor_assets')}/"
    puts rsync
    pipe = IO.popen(rsync)
    while (line = pipe.gets)
      print line
    end
    puts "cloned files"
    puts "done"
  end
end
