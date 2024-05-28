pipeline {
    agent any

	environment {
		TARGET_HOST = '192.168.105.3'
		TARGET_PATH = '/sample_app'
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
        	steps([$class: 'BapSshPromotionPublisherPlugin']) {
        		sshPublisher(
        			continueOnError: false, failOnError: true,
        			publishers: [
        				sshPublisherDesc(
		        			config-name: 'send_artefact',
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
