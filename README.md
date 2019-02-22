# BH Platform
Docker compose to run full environment locally

## Setup

1. Download this project

2. Install docker

    * How to install: https://docs.docker.com/docker-for-mac/install/
    * How to check: `docker --version`
    
3. Increase docker memory to 6Gb

    * https://docs.docker.com/docker-for-mac/#advanced
    
4. Install aws cli

    * How to install: https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html
    * How to check: `aws --version`
    
5. Create aws credentials file

    * Use `aws configure`
        * AWS Access Key ID [None]: `(your access key id, request from aws admin)`
        * AWS Secret Access Key [None]: `(your secret access key, request from aws admin)`
        * Default region name [None]: `us-west-2`
        * Default output format [None]: `(leave empty)`
    * Additional info: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
    * How to check: `cat ~/.aws/credentials`
    
6. Setup access to docker repository

    * One time way
        * Install https://github.com/awslabs/amazon-ecr-credential-helper
        * Open ~/.docker/config.json file (ex. `vi ~/.docker/config.json` or `nano ~/.docker/config.json`)
        * Add the next lines:
        ```$json
            {
                ...
                "credHelpers": {
                    "504788118775.dkr.ecr.us-west-2.amazonaws.com": "ecr-login"
                }
                ...
            }
        ```
    * Alternative way 
        * Use `$(aws ecr get-login --no-include-email --region us-west-2)` each time when you need access

## How to

1. Update environment

    * Go to $PROJECT_HOME
    * Run `BRANCH_NAME=$BRANCH_NAME docker-compose pull`
    
2. Run environment

    * Go to $PROJECT_HOME
    * Run `BRANCH_NAME=$BRANCH_NAME docker-compose up`
    
3. Stop environment

    * Run `BRANCH_NAME=$BRANCH_NAME docker-compose down` (from any directory)
    
4. Stop and fully delete environment (including databases)

    * Run `BRANCH_NAME=$BRANCH_NAME docker-compose -v down` (from any directory)
    
5. Build environment **(the related projects should be in the same directory as the current project)**

    * Go to $PROJECT_HOME
    * Platform team
        * Run `BRANCH_NAME=$BRANCH_NAME docker-compose -f docker-compose-plt.yml build`
    * Web team
        * Run `BRANCH_NAME=$BRANCH_NAME docker-compose -f docker-compose-web.yml build`
        
6. Push environment **(the images should be build first)**

    * Go to $PROJECT_HOME
    * Platform team
        * Run `BRANCH_NAME=$BRANCH_NAME docker-compose -f docker-compose-plt.yml push`
    * Web team
        * Run `BRANCH_NAME=$BRANCH_NAME docker-compose -f docker-compose-web.yml push`
    
    To do an operation **for one instance**, just put instance name to the end of the script
    (ex. `BRANCH_NAME=$BRANCH_NAME docker-compose -f docker-compose-web.yml build web-client`)

## Links

* http://localhost:7000 - web application
* http://localhost:7100 - admin web application
* http://localhost:8080 - bh-api service
* http://localhost:8180 - bh-admin service
