# Deploy a Minecraft Server with Plugins in AWS using Docker + Terraform
![apelaciones y minecraft-mc-architecture drawio](https://github.com/user-attachments/assets/0745e28b-8602-4d82-8bdf-56830a72ac58)
<small>AWS Architecture<small>
## Content

 - [Introduction](#section-1)
 - [Considerations](#section-2)
 - [System Structure](#section-3)
 - [Steps](#section-4)
 - [Acknowledgments](#section-5)
   
<a id="section-1"></a>
## Introduction
Once in a while one feels the urge to reinvent the wheel and prove their knowledge. This is it. 
Tough I later realized actual people can benefit from these project: mainly my college classmates that want to have a good time playing with friends in a private server.

Hope you find this project useful, wheter it's used for learning or deploying your own server.

<a id="section-2"></a>
## Considerations
The dev environment is Linux, so take that into account when applying terraform. 
![image](https://github.com/user-attachments/assets/55c6e4c5-32c3-4a5e-91f9-95f66a533562)
<img src="https://github.com/user-attachments/assets/55c6e4c5-32c3-4a5e-91f9-95f66a533562" width="200" />
Null resources expect to interact with bash (from linux), so you can choose to modify the commands or run with the linux subsystem for windows.

Requirements
- Docker
- Terraform
- Awscli
- An AWS account with enough permissions and credits
As for the permissions, I deployed with admin priviledges and later deactivated the keys. Not the best practice, but works weel enough.

Also take note that you will need to give sudo permissions to execute the commands in the following resource:
![image](https://github.com/user-attachments/assets/021d053d-d9eb-4231-a9c9-d0fd25a2cad6)

<a id="section-3"></a>
## Structure
![despliegue drawio](https://github.com/user-attachments/assets/128db1f0-0cf4-435b-a01a-abe55e2a1380)


## Steps

NOTE: there might be an error when trying to authenticate docker because of the use of sudo command

I am still looking how to solve it
... maybe you will need to authenticate with sudo after all


## Acknowledgements
It's a long journey. Feel free to reach out to me via email at ever.burga.p@uni.pe
