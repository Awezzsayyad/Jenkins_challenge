pipeline {
    agent any
    environment {
        PATH = "/var/lib/jenkins/bin:$PATH"  // Ensure the custom bin path is added to PATH
    }
    stages {
        stage('Install Terraform') {
            steps {
                script {
                    def terraformVersion = '1.0.11'
                    def terraformBin = '/var/lib/jenkins/bin/terraform'

                    // Check if Terraform is already installed
                    def terraformInstalled = sh(script: "which terraform", returnStatus: true)
                    if (terraformInstalled != 0) {
                        echo "Terraform is not installed. Installing version ${terraformVersion}..."
                        sh """
                        curl -O https://releases.hashicorp.com/terraform/${terraformVersion}/terraform_${terraformVersion}_linux_amd64.zip
                        unzip terraform_${terraformVersion}_linux_amd64.zip
                        sudo mv terraform /var/lib/jenkins/bin/
                        terraform --version
                        """
                    } else {
                        echo "Terraform is already installed."
                    }
                }
            }
        }

        stage('Checkout') {
            steps {
                deleteDir()
                sh 'echo cloning repo'
                sh 'git clone https://github.com/rarvez77/ansible-task.git'
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    dir('/var/lib/jenkins/workspace/ansible-tf/ansible-task') {
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
                    sleep(time: 360, unit: 'SECONDS')
                    ansiblePlaybook becomeUser: 'ec2-user', credentialsId: 'amazonlinux', disableHostKeyChecking: true, installation: 'ansible', inventory: '/var/lib/jenkins/workspace/ansible-tf/ansible-task/inventory.yaml', playbook: '/var/lib/jenkins/workspace/ansible-tf/ansible-task/amazon-playbook.yml'
                    ansiblePlaybook become: true, credentialsId: 'ubuntuuser', disableHostKeyChecking: true, installation: 'ansible', inventory: '/var/lib/jenkins/workspace/ansible-tf/ansible-task/inventory.yaml', playbook: '/var/lib/jenkins/workspace/ansible-tf/ansible-task/ubuntu-playbook.yml'
                }
            }
        }
    }
}
