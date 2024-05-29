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
					sh "docker push ${DOCKER_IMAGE}"
				}
			}
		}
		
        stage('Deploy') {
        	steps {
        		ansiblePlaybook(
        			playbook: 'deploy.yml',
        			inventory: 'localhost',
        			extraVars: [
        				TARGET_HOST: "${TARGET_HOST}",
        				TARGET_USER: "${TARGET_USER}",
        				TARGET_PATH: "${TARGET_PATH}",
        				TARGET_KEY_PATH: "${TARGET_KEY_PATH}"
        			],
        			credentialsId: 'ansible-credentials-id'
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
