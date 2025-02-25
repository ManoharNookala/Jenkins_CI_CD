pipeline{
    agent any

    environment {
        DBT_PROJECT_DIR = "JENKINS_CI_CD",
        BQ_PROJECT = "learn-436612"
    }
    triggers {
        cron('H/30 4 * * *') // schedule to run daily at 9:30 AM IST
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
                withCredentials([file(CredentialsId: 'gcp-service-account')]){

                
                dir("${env.DBT_PROJECT_DIR}"){
                    sh 'dbt run'
                }}

            }
        }
        stage('Test dbt'){
            steps{
                withCredentials([file(CredentialsId: 'gcp-service-account')]){

                
                dir("${env.DBT_PROJECT_DIR}"){
                    sh 'dbt test'
                }}

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