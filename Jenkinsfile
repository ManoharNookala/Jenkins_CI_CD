pipeline{
    agent any

    environment {
        DBT_PROJECT_DIR = ".",
        BQ_PROJECT = "learn-436612"
    }
    stages{
        stage('Checkout') {
            steps {
                git 'https://github.com/ManoharNookala/dbt.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install dbt google-cloud-bigquery'
            }
        }

        stage('Run dbt'){
            steps{
                dir("${env.DBT_PROJECT_DIR}"){
                    SH 'dbt run'
                }
            }
        }
        stage('Test dbt'){
            steps{
                dir("${env.DBT_PROJECT_DIR}"){
                    sh 'dbt test'
                }
            }
        }
        stage('Run Bigquery SQL Scripts') {
            steps {
                withCredentials([file(CredentialsId: 'learn-436612', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    script {
                        def sqlFiles = findFiles(glob: '*.sql')
                        for (file in sqlFiles) {
                            def sqlQuery = readFile(file.path)
                            sh "bq query --use_legacy_sql=false --project_id=${BQ_PROJECT} '${sqlQuery}" 
                        }
                    }
                }
            }
        }
        post {
        always {
            // Clean up if needed
            cleanWs()
        }
    }
    }
}