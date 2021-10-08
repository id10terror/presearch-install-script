#!/bin/bash
echo
echo "################################################"
echo "##                                            ##"
echo "## Presearch Node Install Script [Unofficial] ##"
echo "## for Ubuntu Server  by id10terror           ##"
echo "##                                            ##"
echo "## twitter: @id_10t_error                     ##"
echo "##                                            ##"
echo "################################################"
echo

if [ ! `whoami` = "root" ]; then
 echo "Run script as root or use sudo to elevate priveledges."
 exit 1;
fi

if [ ! $(. /etc/os-release && echo "$ID") = "ubuntu" ]; then
 echo "Need to be running Ubuntu to use this script. Exiting."
 exit 1;
fi

CONFIG_DIR=/opt/docker/presearch
CONFIG_URL=https://github.com/id10terror/presearch-install-script/raw/main/docker-compose.yml

# Install some Docker pre-reqs
sudo apt update -y; 
#sudo apt upgrade -y; 
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release -y;

# Create Docker Ubuntu Repo config
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg;
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;

# Install Docker and docker-compose
sudo apt update; 
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose -y;

# Create directory for docker-compose file and presearch key files
[ ! -d $CONFIG_DIR/app/node ] && sudo mkdir -p $CONFIG_DIR/app/node; 

# Ask User for Presearch Registration Code
echo
echo
echo "Your Unique Presearch Node Registration Code can be found at:"
echo "https://nodes.presearch.org/dashboard"
echo "Enter Node Registration Code: "
read NODE_REG_CODE </dev/tty ;
echo

# Creates .env file which will contain the 
# Presearch Registration Code variable used by docker-compose
sudo echo "REGCODE=$NODE_REG_CODE" > $CONFIG_DIR/.env;
sudo echo "NODE_DIR=$CONFIG_DIR/app/node:/app/node" >> $CONFIG_DIR/.env;

# Download docker-compose config file from github repo
sudo curl $CONFIG_URL --output $CONFIG_DIR/docker-compose.yml;

# Creates docker system account and adds to docker group
# Assigns the new docker account as owner of new directory
sudo useradd -r docker -g docker; 
sudo chown -R docker:docker $CONFIG_DIR;

# Creates new containers using docker-compose
(cd $CONFIG_DIR; sudo docker-compose -f $CONFIG_DIR/docker-compose.yml up -d --force-recreate;)

# Display Container logs. CTRL+C to exit
echo
echo "Displaying docker container log..."
echo "Press CTRL+C to stop streaming log."
echo

sudo docker-compose -f $CONFIG_DIR/docker-compose.yml logs -f;
