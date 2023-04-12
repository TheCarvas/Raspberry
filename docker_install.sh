 
###Docker installation following guidelines in https://docs.docker.com/engine/install/debian/#install-using-the-repository

cat << "EOF"
  ____ ___      _            _     _           _     
 |  _ \_ _|    / \   ___ ___(_)___| |_ ___  __| |    
 | |_) | |    / _ \ / __/ __| / __| __/ _ \/ _` |    
 |  __/| |   / ___ \\__ \__ \ \__ \ ||  __/ (_| |    
 |_|_ |___| /_/ _ \_\___/___/_|___/\__\___|\__,_|    
 |_ _|_ __  ___| |_ __ _| | | __ _| |_(_) ___  _ __  
  | || '_ \/ __| __/ _` | | |/ _` | __| |/ _ \| '_ \ 
  | || | | \__ \ || (_| | | | (_| | |_| | (_) | | | |
 |___|_| |_|___/\__\__,_|_|_|\__,_|\__|_|\___/|_| |_|
EOF

                                                    

#Update the apt package index and install packages to allow apt to use a repository over HTTPS:

echo -e "\n\n\t\t Lets start with updating base kernel packages! \n\n"

sudo apt-get update
yes | sudo apt-get install \
    ca-certificates \
    curl \
    gnupg

echo -e "\n\n\t\t PACKAGES SUCCESSFULLY UPDATED! \n\n"


echo -e "\n\n\t\t Setting docker repo's and keys hold tight! \n\n"

#Add Docker’s official GPG key:

sudo mkdir -m 0755 -p /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Use the following command to set up the repository associated with the sysem architecture, since there is no i386 package amd64 must be used:


architecture=$(dpkg --print-architecture)

if [ $architecture == "i386" ]; then
  architecture="amd64"
fi
echo \
"deb [arch="$architecture" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Update the apt package index:
#granting read permission for the Docker public key file before updating the package index
#in case default umask may be incorrectly configured, preventing detection of the repository public key file. 

 sudo chmod a+r /etc/apt/keyrings/docker.gpg
 sudo apt-get update


echo -e "\n\n\t\t All dependencies updated, starting Docker installation \n\n"

#Add user to docker group
sudo groupadd docker
sudo usermod -aG docker $USER


#Install Docker Engine, containerd, and Docker Compose.

yes | sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


sudo docker run hello-world

echo -e "\n\n\t\t Setting docker to run on startup \n\n"

sudo systemctl enable docker