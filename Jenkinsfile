pipeline {
    agent any

    tools {
	go 'go-1.22'
    }
    stages {
        stage('Hello') {
            steps {
                sh 'go build main.go'
		sh 'ls -la'
		sh 'echo done.'
            }
        }
    }
}
