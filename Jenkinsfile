pipeline {
    agent any

	environment {
		TARGET_HOST = '192.168.105.3'
		TARGET_NAME = 'send_artefact'
		TARGET_PATH = 'sample_app/'
	}
	
    tools {
		go 'go-1.22'
    }
    
    stages {
		stage('Checkout') {
			steps {
				checkout scm
			}
		}

        stage('Build') {
            steps {
                sh 'go build -o main main.go'
                sh 'ls -l'
            }
        }

        stage('Deploy') {
        	steps([$class: 'BapSshPromotionPublisherPlugin']) {
        		sshPublisher(
        			continueOnError: false, failOnError: true,
        			publishers: [
        				sshPublisherDesc(
        					configName: TARGET_NAME,
        					verbose: true,
        					transfers: [
        						sshTransfer(
        							sourceFiles: 'main/**',
        							remoteDirectory: TARGET_PATH
        						)
        					]
        				)
        			]
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
