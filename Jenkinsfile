pipeline {
    agent any

    environment {
        PATH = "$HOME/bin:/usr/local/bin:${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                deleteDir()
                sh '''
                echo "Cloning repository..."
                git clone https://github.com/Awezzsayyad/Jenkins_challenge.git
                '''
            }
        }
        
        stage('Install Terraform') {
            steps {
                sh '''
                echo "Installing Terraform..."
                curl -O https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip
                unzip terraform_1.0.11_linux_amd64.zip
                mkdir -p $HOME/bin
                mv terraform $HOME/bin/
                terraform --version
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('Jenkins_challenge/ansible-task') {
                    sh '''
                    echo "Initializing Terraform..."
                    terraform init
                    terraform validate
                    terraform plan
                    terraform apply -auto-approve
                    '''
                }
            }
        }
        
        stage('Ansible Deployment') {
            steps {
                script {
                    echo "Starting Ansible deployment..."
                    ansiblePlaybook becomeUser: 'ec2-user', 
                        credentialsId: 'amazonlinux', 
                        disableHostKeyChecking: true, 
                        installation: 'ansible', 
                        inventory: 'Jenkins_challenge/ansible-task/inventory.ini', 
                        playbook: 'Jenkins_challenge/ansible-task/amazon-playbook.yml', 
                        vaultTmpPath: ''
                        
                    ansiblePlaybook become: true, 
                        credentialsId: 'ubuntuuser', 
                        disableHostKeyChecking: true, 
                        installation: 'ansible', 
                        inventory: 'Jenkins_challenge/ansible-task/inventory.ini', 
                        playbook: 'Jenkins_challenge/ansible-task/ubuntu-playbook.yml', 
                        vaultTmpPath: ''
                }
            }
        }
    }
}
