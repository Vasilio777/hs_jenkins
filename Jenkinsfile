pipeline {
    agent any

	}
	
    tools {
		go 'go-1.22'
    }
    
    stages {
        stage('Build app') {
            steps {
                sh 'mkdir -p build && go build -o build/main'
            }
        }

		stage('Dockerize') {
			steps {
				withEnv(['DOCKER_IMAGE=DOCKER_IMAGE'])
				sh 'docker build -t $DOCKER_IMAGE .'
			}
		}

		stage('Push Docker Image') {
			steps {
				withDockerRegistry([credentialsId: 'docker-credentials-id']) {
					sh 'docker push ${env.DOCKER_IMAGE}'
				}
			}
		}
		
        stage('Deploy') {
        	steps {
        		ansiblePlaybook(
        			playbook: 'deploy.yml',
        			inventory: 'localhost',
        			extraVars: [
        				TARGET_HOST: '${env.TARGET_HOST}',
        				TARGET_USER: '${env.TARGET_USER}',
        				TARGET_PATH: '${env.TARGET_PATH}',
        				TARGET_KEY_PATH: '${env.TARGET_KEY_PATH}'
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
