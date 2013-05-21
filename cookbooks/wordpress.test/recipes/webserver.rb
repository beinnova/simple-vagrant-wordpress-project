#
# Cookbook Name:: wordpress
# Recipe:: webserver
#

app_name = 'wordpress.test'
wordpress = node['wordpress']
app_config = node[app_name]
#app_secrets = Chef::EncryptedDataBagItem.load("secrets", app_name) 

include_recipe "apt"
include_recipe "apache2"
include_recipe "apache2::mod_php5"

package "curl"
package "git"

# Set up the Apache virtual host 
web_app app_name do 
  server_name app_config['server_name']
  docroot app_config['docroot']
  #server_aliases [node['fqdn'], node['hostname']]
  template "#{app_name}.conf.erb" 
  log_dir node['apache']['log_dir'] 
end

wp_db = wordpress['db']['database']
db_passwd = node['mysql']['server_root_password']
db_user = 'root'
mysql_root = '/usr/bin/mysql'

mysql_connection_info={
	:host=>"localhost",
	:username=> db_user,
	:password => db_passwd
}

#Creao il Db
mysql_database 'worpressdb' do
	connection mysql_connection_info
	action :create	
end


#Creo lo user
mysql_database_user 'wordpressuser' do
	connection mysql_connection_info
	password 'wordpresspasswd'
	action :create
end

#Assegno privilegi  sul database allo user creato
mysql_database_user 'wordpressuser' do
	connection mysql_connection_info
	password 'wordpresspasswd'
	database_name 'wordpressdb'
	host 'localhost'
	privileges [:all]
	action :grant
end


