pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                deleteDir()
                sh 'echo cloning repo'
                sh 'git clone https://github.com/Awezzsayyad/Jenkins_challenge.git' 
            }
        }
        
        stage('Install Terraform') {
            steps {
                sh '''
                    if ! [ -x "$(command -v terraform)" ]; then
                      echo "Installing Terraform..."
                      curl -O https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip
                      unzip terraform_1.0.11_linux_amd64.zip
                      sudo mv terraform /usr/local/bin/
                    else
                      echo "Terraform is already installed"
                    fi
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    dir('Jenkins_challenge/ansible-task') {
                    sh 'pwd'
                    sh 'terraform init'
                    sh 'terraform validate'
                    // sh 'terraform destroy -auto-approve'
                    sh 'terraform plan'
                    sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
        
        stage('Ansible Deployment') {
            steps {
                script {
                   sleep '360'
                    ansiblePlaybook becomeUser: 'ec2-user', credentialsId: 'amazonlinux', disableHostKeyChecking: true, installation: 'ansible', inventory: 'Jenkins_challenge/ansible-task/inventory.ini', playbook: 'Jenkins_challenge/ansible-task/amazon-playbook.yml', vaultTmpPath: ''
                    ansiblePlaybook become: true, credentialsId: 'ubuntuuser', disableHostKeyChecking: true, installation: 'ansible', inventory: 'Jenkins_challenge/ansible-task/inventory.ini', playbook: 'Jenkins_challenge/ansible-task/ubuntu-playbook.yml', vaultTmpPath: ''
                }
            }
        }
    }
}
