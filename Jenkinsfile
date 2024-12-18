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
        
        stage('Terraform Apply') {
    steps {
        dir('Jenkins_challenge/path-to-terraform-files') {
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
