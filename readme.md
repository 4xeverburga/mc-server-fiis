# Deploy a Minecraft Server with Plugins in AWS using Docker + Terraform
![apelaciones y minecraft-mc-architecture drawio](https://github.com/user-attachments/assets/0745e28b-8602-4d82-8bdf-56830a72ac58)
<small>AWS Architecture<small>
## Content

 - [Introduction](#section-1)
 - [Considerations](#section-2)
 - [System Structure](#section-3)
 - [Steps](#section-4)
 - [Contact Us](#section-5)
   
<a id="section-1"></a>
## Introduction
Once in a while one feels the urge to reinvent the wheel and prove their knowledge. This is it. 
Tough I later realized actual people can benefit from these project: mainly my college classmates that want to have a good time playing with friends in a private server.

Hope you find this project useful, wheter it's used for learning or deploying your own server.

<a id="section-2"></a>
## Considerations
The dev environment is Linux, so take that into account when applying the commands. 
<p align=center>
<img src="https://github.com/user-attachments/assets/55c6e4c5-32c3-4a5e-91f9-95f66a533562" width="600"/>
</p>

Null resources expect to interact with bash (from linux), so you can choose to modify the commands or run with the linux subsystem for windows.

### Requirements
- Docker
- Terraform
- Awscli
- An AWS account with enough permissions and credits
- A Linux system to run the commands and follow along.
  
As for the permissions, I deployed with admin priviledges and later deactivated the keys. Not the best practice, but works well enough.

Also take note that you will need to give sudo permissions to execute the commands in the following resource:
<p align=center>
<img src="https://github.com/user-attachments/assets/021d053d-d9eb-4231-a9c9-d0fd25a2cad6" width="500"/>
</p>

<a id="section-3"></a>

## Structure and Initialization
### Deployment(ish) Diagram 
This is the state of the system after it is deployed.
<p align=center>
<img src="https://github.com/user-attachments/assets/7df1a0f8-269e-4031-9f6b-79758ca45b97" width="500"/>
</p> 
I find useful to group the deployment nodes into EC2, ECR and S3. So bear with me and those terms from now on.

### Communication Diagram
You can see the messages that the components send to each other as a still picture.

I want to note that the two bucket icons are actually the same bucket, but only ```world/```  recieves backup
<p align=center>
<img src="https://github.com/user-attachments/assets/585d9cd5-ce75-44d7-973f-e67c02452b63" width="800"/>
</p> 

When you kickstart the deployment with Terraform, you can follow the initialization steps this way:
1. The ECR is created and your local image is pushed there to be later called by EC2.
2. An S3 bucket is created and filled with data uploaded from your dev environment. This includes 
server and plugins config. files, map data, automation scripts and the docker compose file.

_Note that scripts/ in S3 does not have the same content as scripts/ in your dev environment, but rather scripts/host-machine/_

4. An EC2 instance is provisoned for the server, the data from S3 is synced into EC2 and the configuration script in ```scripts/config-and-launch-server.bash``` runs at boot. You will be good in reading it if you want to know more details about this step.
After the scripts executes, you end up with some long-lasting processes:
-  A ```mc-server.service``` systemctl service
- A cronjob for backup, running ```aws s3 cp /home/ec2-user/world/ s3://data-for-mc-server/world/ --recursive``` every hour.
 

<a id="section-4"></a>
## Steps

Execute ```clean.sh``` before trying terraform.

### Test in your dev computer
- Optional: Copy the content of your minecraft map into the world dir. This way the server will load with your custom map.
- Optional: Copy the passwords of your passky server if you wish your new deploy to use themThen delete or re-tag
- Optional: Add your favourite plugins in ```plugins/``` dir. Your are in charge of updating and ensuring compatibility of the plugins.
1. Build the image mc-dev with ```sudo docker build -t mc-dev .``` 
2. Run ```$ docker compose up```
3. Connect to the local server in your minecraft client. The connection string should look like this: 127.0.0.1:25565

### Deploy to aws
- Optional: Copy the content of your minecraft map into the world dir. This way the server will load with your custom/backup map.
- Optional: Copy the passwords of your passky server if you wish your new deploy to use them. That way you can backup your old server passwords
- Optional: Add your favourite plugins in ```plugins/``` dir. Your are in charge of updating and ensuring compatibility of the plugins.
1. Build the image and tag it as mc:latest with ```sudo docker build -t mc:latest .```. This will be used by a terraform null resource to push to ecr. 
2. cd into terraform and execute ```$ terraform apply```
3. You will probably be required to enter your password to access sudo permisions for docker push, otherwise the progress will freeze.
4. Now you can connect to the ec2 ip. The connection strign should look like this: 3.0.2.125:25565.
- Optional: You can attach an elastic ip to your ec2 instance and link it to your own custom domain. That way you can get a domain name like mc.yourdomain.net

<a id="section-5"></a>
## Contact Us
Learning is a long journey. Feel free to reach out to me via email at ever.burga.p@uni.pe

- Shout-out to the map designer: Edward Lluen (BmYoru).
- Software design and developement by Ever Burga.
