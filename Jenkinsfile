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
        stage('Build') {
            steps {
                sh 'mkdir -p build && go build -o build/main'
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
        							sourceFiles: 'build/**',
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
