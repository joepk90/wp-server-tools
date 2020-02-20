if [ "$1" = "push" ]
then
printf "\ndeploying your local database to the dev server! \n"
elif [ "$1" = "stop" ]
then
printf "\ncloninf database from the dev server! \n"
fi


read -p 'what is your database file called? ' database_file_name
read -p 'what is your servers username? ' server_user_name
read -p 'what is the domain of the server? ' server_ip
read -p 'where do you want to copy your files to? ' server_path
read -p 'where is the server port? ' server_port
read -p 'where is the domain of the site you are copying from? (dont include the http protocol) ' local_site_name
read -p 'where is the domain of the site you are pushing too? (dont include the http protocol)' server_site_name

if [ "$1" = "push" ]
then
# wp db export database-export.sql
rsync -avzhe "ssh -p 22" $database_file_name $server_user_name@$server_ip:$server_path
ssh -o "StrictHostKeyChecking no" $server_user_name@$server_ip -p $server_port -t "cd $server_dir_path; wp db import $database_file_name; wp search-replace '$local_site_name'  '$server_site_name' --all-tables; exit; bash"

# # else if [  "$1" = "pull" ]
# # then

# # exit # NEEDS TESTING!

# # printf "\nexporting database on server \n"

# # ssh -o "StrictHostKeyChecking no" $user_name@$server_ip -p $server_port -t "cd $server_dir_path; wp db export docker-db.sql; exit; bash"

# # # copy database to docker project directory

# # printf "\ncopy database from server to local \n"
# # rsync -chavzP -e "ssh -p $server_port" $user_name@$server_ip:$server_dir_path/docker-db.sql ./

# # printf "\ncleaning up - delete database on server \n"
# # ssh -o "StrictHostKeyChecking no" $user_name@$server_ip -p $server_port -t "cd $server_dir_path; rm docker-db.sql; exit; bash"
fi