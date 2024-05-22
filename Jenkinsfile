pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                sh 'go build main.go'
		sh 'ls -la'
            }
        }
    }
}
