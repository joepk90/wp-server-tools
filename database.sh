if [ "$1" = "push" ]
then
printf "\ndeploying your local database to the dev server! \n"
else if [  "$1" = "pull" ]
then
printf "\ncloning the database from the dev server! \n"
else
echo "no argument provided. do you want to push or pull the database?"
fi


read -p 'what is your servers username? ' server_user_name
read -p 'what is the host or IP address of the server? ' server_ip
read -p 'where do you want to copy your files to? ' server_path

if [ "$1" = "push" ]

then
wp db export database-export.sql
rsync -avzhe "ssh -p 22" database-export.sql $server_user_name@$server_ip:$server_path



else if [  "$1" = "pull" ]
then

exit # NEEDS TESTING!

printf "\nexporting database on server \n"

ssh -o "StrictHostKeyChecking no" $user_name@$server_ip -p $server_port -t "cd $server_dir_path; wp db export docker-db.sql; exit; bash"

# copy database to docker project directory

printf "\ncopy database from server to local \n"
rsync -chavzP -e "ssh -p $server_port" $user_name@$server_ip:$server_dir_path/docker-db.sql ./

printf "\ncleaning up - delete database on server \n"
ssh -o "StrictHostKeyChecking no" $user_name@$server_ip -p $server_port -t "cd $server_dir_path; rm docker-db.sql; exit; bash"

fi
