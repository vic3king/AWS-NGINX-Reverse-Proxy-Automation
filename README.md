# AWS-NGINX-Reverse-Proxy-Automation

Provisioning NGINX reverse proxy server on AWS EC2 instance using `screen` to run a python backend application in the background and using letsencrypt to install SSL on the project.

## How to run the Application

- Create an AWS account [here](aws.amazon.com)
- Create an Amazon EC2 instance with this guide [here](https://docs.aws.amazon.com/efs/latest/ug/gs-step-one-create-ec2-resources.html)
- Create security group for HTTP, HTTPS, SSH so that the app can be accessible on the IP address of the EC2 instance and the domain name you have specified in the shell script. This is made possible by the reverse proxy setup by nginx from your app port to the port 80.
- Generate and download a keypair
- Register a domain name of your choice with any provider, the domain name will be used later (when configuring Route53 on the instance).
- On your terminal, cd into the downloaded keypair directory and grant `read access` using `chmod 400 <keypair>`. The keypair is a file with a .pem extension. Practice on file permissions [here](http://permissions-calculator.org/)
- ssh into the EC2 instance using this format `ssh -i <.pem file> <user>@<IP address>`. Example ssh -i demo.pem ubuntu@13.57.186.168
- Create a file with a .sh extension and paste the contents of script.sh into it. You can use vim or nano to achieve this `vim script.sh` or `nano script.sh`
- Create a `.env` file and fill it up with the details specified in the .env.sample file.
- Install and start the project with running the bash script you created. `sudo bash script.sh`
- Monitor the processes in your terminal as the different functions are called accordingly.
- After the script is done, access the application with the public IP address of the EC2 instance.
- Use AWS Route53 to redirect traffic from your IP address to the domain name you purchased. Copy the name servers from your AWS account and paste the on the name servers of the domain name to complete the redirect-cycle