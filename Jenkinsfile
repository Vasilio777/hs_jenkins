pipeline {
    agent any
	
    tools {
		go 'go-1.22'
    }
    
    stages {
        stage('Build app') {
            steps {
                sh "mkdir -p build && go build -o build/main"
            }
        }

		stage('Dockerize') {
			steps {
				sh "docker build -t ${env.DOCKER_IMAGE} ."
			}
		}

		stage('Push Docker Image') {
			steps {
				withDockerRegistry([url: '', credentialsId: 'docker-credentials-id']) {
					sh "docker push ${env.DOCKER_IMAGE}"
				}
			}
		}
		
        stage('Deploy') {
        	steps {
        		ansiblePlaybook(
        			installation: 'ansible',
        			playbook: 'deploy.yml',
        			inventory: 'localhost,',
        			extraVars: [
        				TARGET_HOST: "${env.TARGET_HOST}",
        				TARGET_USER: "${env.TARGET_USER}",
        				TARGET_PATH: "${env.TARGET_PATH}",
        				DOCKER_IMAGE: "${env.DOCKER_IMAGE}"
        			],
        			credentialsId: 'send_artefact'
        		)
        	}
        }
    }

    post {
    	always {
    		cleanWs()
    	}
    }
}
