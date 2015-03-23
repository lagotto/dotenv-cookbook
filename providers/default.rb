def whyrun_supported?
  true
end

use_inline_resources

def load_current_resource
  @current_resource = Chef::Resource::Dotenv.new(new_resource.name)
end

action :load do
  chef_gem "dotenv" do
    compile_time false if respond_to?(:compile_time)
    action :install
  end

  # load ENV variables from file specified by dotenv atrribute
  # use .env when dotenv is "default"
  require 'dotenv'
  ENV["DOTENV"] = new_resource.dotenv
  filename = new_resource.dotenv == "default" ? ".env" : ".env.#{new_resource.dotenv}"
  ::Dotenv.load! "/var/www/#{new_resource.name}/shared/#{filename}"
end
