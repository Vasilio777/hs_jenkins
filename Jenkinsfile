pipeline {
    agent any

	environment {
		props = readFile('.env').split('\n').findAll { it.trim() && !it.startsWith('#') }
		for (line in props) {
			def parts = line.split('=')
			env["$parts[0].trim()"] = parts[1].trim()
		}
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
				sh 'docker build -t ${env.DOCKER_IMAGE} .'
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
