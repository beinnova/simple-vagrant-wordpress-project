package "git"

#Creo la public_html

execute "create-public_html_folder" do
    command "mkdir -p /home/vagrant/public_html"
end


#Scarico Wordpress da git

git "/home/vagrant/public_html" do
    repository "https://github.com/WordPress/WordPress.git"
    reference "3.5"
    action :sync
end
