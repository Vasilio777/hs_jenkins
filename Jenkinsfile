pipeline {
    agent any

	environment {
		TARGET_HOST = '192.168.105.3'
		TARGET_NAME = 'target'
		TARGET_PATH = '/sample_app'
		SSH_CREDENTIALS_ID = 'send_artefact'
	}
	
    tools {
	go 'go-1.22'
    }
    
    stages {
        stage('Build') {
            steps {
                sh 'go build -o main main.go'
            }
        }

        stage('Deploy') {
        	steps {
        		sshPublisher(publishers: [sshPublisherDesc(
        			config-name: SSH_CREDENTIALS_ID,
        			transfers: [sshTransfer(
        				sourceFiles: '/main',
        				remoteDirectory: TARGET_PATH
        			)],
        			usePromotionTimestamp: false,
        			useWorkspaceInPromotion: false,
        			verbose: true
        		)])
        	}
        }
    }

    post {
    	always {
    		cleanWs()
    	}
    }
}
