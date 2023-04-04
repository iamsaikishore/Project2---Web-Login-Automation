# Project2---Web-Login-Automation
 ### End-to-End DevOps Project using Terraform

## Tools Used:
* Git, GitHub, Github Actions
* Jenkins
* Docker
* Terraform
* AWS (ECS, ECR, VPC, LoadBalancer, Cloudwatch, S3, DynamoDB, EC2, IAM), AWS CLI

First login to your linux server by creating an EC2 instance.

### Configuring Tools:
#### Configuring Git:
```Shell
$ sudo yum install git -y
```
```shell
$ git version
```

#### Configuring Jenkins:
```shell
$ sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
$ sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
$ sudo yum upgrade -y
# Add required dependencies for the jenkins package
$ sudo yum install java-11-openjdk -y
$ sudo yum install Jenkins -y

$ sudo systemctl start Jenkins.service
```

Now in the browser, search with ip address of the instance and port number ```(ex: 10.0.0.1:8080)```
```shell
$ cat /var/lib/jenkins/secrets/initialAdminPassword
```
Copy the password in Jenkins, install the plugins and create a user.

#### Configuring Docker:
```shell
$ sudo yum install -y yum-utils
$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/rhel/docker-ce.repo
$ sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
$ sudo systemctl start docker
```
Verify that Docker Engine is installed correctly by running the ```hello-world``` image.
```shell
$ sudo docker run hello-world
```
Add the user to docker group
```shell
$ usermod -aG docker <username>
```
#### Configuring Terraform:
```shell
$ sudo yum install -y yum-utils
$ sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
$ sudo yum -y install terraform
```
```shell
$ terraform version
```

#### Configuring AWS CLI:
```shell
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
```
Now go to AWS IAM Console and create a user with Programmatic Access and attach the required policies, in my case i have attached AdministrativeAccess and note the ACCESS_KEY and SECRET_ACCESS_KEY.
```shell
$ aws configure
```
Give the ACCESS_KEY, SECRET_ACCESS_KEY, REGION and FORMAT.

### Project Begins
Now create a directory and clone the git repository
```shell
$ mkdir project_web && cd project_web
$ git clone https://github.com/iamsaikishore/Project2---Web-Login-Automation.git
$ cd Project2---Web-Login-Automation
```
![Screenshot (159)](https://user-images.githubusercontent.com/129657174/229813136-5e3b727d-5d66-4ca6-b89b-1c14a0b2fca5.png)

Now check the Dockerfile where we have taken the base image as ubuntu:latest and installed apache server and copied the application files and starting the apache server in foreground

![Screenshot (160)](https://user-images.githubusercontent.com/129657174/229815166-86696e6f-bdf1-437e-aa32-5312e396bf76.png)

Now go to devops/ directory and check the terraform configuration file ```cd devops/```. Go through each terraform configuration file to know how the resources will provisioned. 

![Screenshot (161)](https://user-images.githubusercontent.com/129657174/229815184-ac4458be-ee8e-47b6-9f05-d40e9281fe34.png)

Now check the Github Actions workflow yaml file which is equivalent to jenkins pipeline

![Screenshot (162)](https://user-images.githubusercontent.com/129657174/229817529-4cafce46-0333-430f-9b27-75b9926e2f31.png)

![Screenshot (163)](https://user-images.githubusercontent.com/129657174/229817541-db664043-44d0-4ee4-85e8-3210c805eff6.png)

#### This appears to be a YAML file defining a GitHub Actions workflow for a continuous integration (CI) process. Here's a breakdown of what each part of the file is doing:

```name: CI``` This sets the name of the workflow to "CI".

```on:``` This defines the event that triggers the workflow, in this case a push to any tag in the repository.

```jobs:``` This section defines the jobs that will be run as part of the workflow.

```build:``` This is the name of the first job.

```runs-on:``` self-hosted: This specifies that the job will be run on a self-hosted runner, which is a machine that the user has set up themselves rather than using GitHub's hosted runners.

```steps:``` This is an array of steps that will be executed as part of the job.

```name:``` Check out the repo: This step checks out the repository that the workflow is running on.

```name:``` Set Release version: This step sets an environment variable called "RELEASE_VERSION" to the value of the tag that triggered the workflow.

```name:``` build docker image and push to ecr repo: This step builds a Docker image for a Node.js application and pushes it to an Amazon Elastic Container Registry (ECR) repository.

```env:``` This specifies environment variables that will be available during the execution of the step.
AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_REGION are all environment variables used to authenticate and authorize AWS operations via AWS CLI.

```name:``` Check tag version: This step echoes the value of the "RELEASE_VERSION" environment variable and some other environment variables that have been set during the workflow.

```name:``` terraform initialization: This step initializes the Terraform configuration for deploying the application infrastructure.

```name:``` terraform deployment: This step applies the Terraform configuration with a variable called "tag" set to the value of the "RELEASE_VERSION" environment variable, which ensures that the correct version of the application is deployed. The "-auto-approve" flag automatically approves any prompts from Terraform, making the deployment process fully automated.

Now go to GitHub and create a repository.

Now push the code to your GitHub repository.
```shell
$ git init
$ git add .
$ git commit -m "your_commit_message"
$ git add remote origin <your_githubrepo_url>
$ git push origin master
```

![Screenshot (164)](https://user-images.githubusercontent.com/129657174/229846446-244a0ddf-e667-4b62-bbd4-457daa62a8ef.png)

As we mentioned in github workflow yaml file ```main.yml```. we have to add secret variables. For that go to repository ```Settings``` --> ```Secrets and variables``` --> ```Actions``` and click ```New repository secret``` and add secrets.

#### For example:
* AWS_REGION             :   ap-south-1
* AWS_ACCESS_KEY_ID      :   AKIAWALDQDO2GTG57X4G
* AWS_SECRET_ACCESS_KEY  :   dQSOkcNHQW7XIzee9QfVI+ApOpJAo8HrL19AFk+T
* ECR_REPO_NAME          :   411976891657.dkr.ecr.ap-south-1.amazonaws.com (411976891657 is AWS Account ID)

![Screenshot (165)](https://user-images.githubusercontent.com/129657174/229851386-dbb1c037-d7be-453c-accd-cfc1497a4c8d.png)

![Screenshot (166)](https://user-images.githubusercontent.com/129657174/229851403-d602186d-0f69-4702-aa99-a34ba9bdaebb.png)

![Screenshot (167)](https://user-images.githubusercontent.com/129657174/229851411-1334be74-b71a-42d0-abff-1d790c1bb708.png)

![Screenshot (168)](https://user-images.githubusercontent.com/129657174/229851415-ed6a5682-669e-4dbb-b561-15dcba69b43e.png)

As we mentioned ```runs-on: self-hosted``` in github workflow yaml file ```main.yml```, for that launch an EC2 instance with Ubuntu image.
Now go to repository ```Settings``` --> ```Actions``` --> ```Runners``` and click ```New self-hosted runner```

![Screenshot (169)](https://user-images.githubusercontent.com/129657174/229855811-99f66427-5e80-4ad4-af4e-54819ae2fdf0.png)

Now Select the appropriate options and run the mentioned commands on ubuntu server.

![Screenshot (170)](https://user-images.githubusercontent.com/129657174/229858842-0fac207b-316f-42d2-9a48-046833e46df9.png)

![Screenshot (172)](https://user-images.githubusercontent.com/129657174/229858849-2142d965-19c5-4c3b-8ae1-ad1e4c46495c.png)

Now check the Runners.

![Screenshot (174)](https://user-images.githubusercontent.com/129657174/229859929-26e61b00-485e-4a1e-8f02-7cc60a9180ff.png)

![Screenshot (175)](https://user-images.githubusercontent.com/129657174/229859935-2753c913-8447-4473-adcf-01dad2176d88.png)

![Screenshot (176)](https://user-images.githubusercontent.com/129657174/229859942-82f0f845-18d5-488d-a54f-4ca1b7c2983a.png)

Now create a tag which will trigger the CI Job ```Releases``` --> ```Draft a new release``` --> ```Choose a tag``` -->  Enter v1.0 --> ```+ Create new tag:v1.0``` --> Publish release this will trigger the CI Job.


![Screenshot (177)](https://user-images.githubusercontent.com/129657174/229862034-bcac5a09-90a6-4744-beeb-cd5d5d28cb16.png)

![Screenshot (178)](https://user-images.githubusercontent.com/129657174/229862041-df511646-df50-4dc6-848f-1c239044bd63.png)

Now ```Actions``` --> ```CI``` --> ```Initial Updates``` --> ```build```

![Screenshot (182)](https://user-images.githubusercontent.com/129657174/229866049-cec35c32-889c-4974-8402-463021318d96.png)

![Screenshot (179)](https://user-images.githubusercontent.com/129657174/229864048-9a467ac4-ad57-4e2e-b3c1-1cdf5f59b0e4.png)

Now copy the loadbalancer dns ``kishq-load-balancer-572781093.***.elb.amazonaws.com`` and replace '***' with the AWS Region ``kishq-load-balancer-572781093.ap-south-1.elb.amazonaws.com`` and search in the browser.

![Screenshot (181)](https://user-images.githubusercontent.com/129657174/229864058-d80a9959-fdd0-43cf-b0eb-19546a8dbc4f.png)

### Hurrayyyyyyyyy! We have deployed the application successfully.

**Hope you all are Enjoyed**

For the original Project click the below links.

[GitHub Repo](https://github.com/jmstechhome8/web_login_automation.git)

[Youtube](https://www.youtube.com/watch?v=T5I6fvH0h88&t=4535s)
