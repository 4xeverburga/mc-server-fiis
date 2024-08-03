# amazon linux config for minecraft server
mkdir app
cd app
yum install -y wget
yum install -y java-22-amazon-corretto-headless 
wget https://piston-data.mojang.com/v1/objects/145ff0858209bcfc164859ba735d4199aafa1eea/server.jar
echo "eula=true" > eula.txt

cd /etc