# Update apt
sudo apt update

# Get properties
sudo apt install software-properties-common apt-transport-https wget -y

# Get download key
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -

# Use the link to get the latest version of VS
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

# Again update apt
sudo apt update

# Install VS Code
sudo apt install code

# To run
# chmod +x vs.sh
# ./vs.sh

#Arigato!
