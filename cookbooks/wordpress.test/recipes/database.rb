include_recipe "apt"
#include_recipe "mysql"
#include_recipe "mysql::client"
#include_recipe "mysql::server"


package "curl"
package "git"

##Configurazione enviroment applicazione ##

app_name = 'wordpress.test'
app_config = node[app_name]
db_name = app_config['db_name']
db_user = app_config['db_user']
db_passwd = app_config['db_passwd']

db_root_user = 'root'
db_root_passwd = 'root'

#Informazioni di connessione a mysql-server

mysql_connection_info = {

	:host=>"localhost",
	:username=> db_root_user,
	:password => db_root_passwd
}

include_recipe "database::mysql"
#Creo il Db
mysql_database db_name do
	connection mysql_connection_info
	action :create
end


#Creo lo user
mysql_database_user db_user do
	connection mysql_connection_info
	password db_passwd
	action :create
end

#Assegno privilegi  sul database allo user creato

mysql_database_user db_user do
	connection mysql_connection_info
	password db_passwd
	database_name db_name
	host 'localhost'
	privileges [:all]
	action :grant
end
