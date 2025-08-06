#version 2 manifest defined in pipline
pipeline {
    agent any
    environment {
        GIT_REPO_NAME = "Tetris-Manifest"
        GIT_USER_NAME = "ShivamGupta31"
    }
    stages {
        stage('Code Checkout Manifest') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: "https://github.com/${env.GIT_USER_NAME}/${env.GIT_REPO_NAME}.git"
            }
        }
        stage('Image Updater') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'git-token', variable: 'GITHUB_TOKEN')]) {
                        def NEW_IMAGE_NAME = "shivamgupta31/tetrisv2.0:latest"
                        sh "sed -i 's|image: .*|image: ${NEW_IMAGE_NAME}|' deployment.yml"
                        sh 'git add deployment.yml'
                        sh "git commit -m 'Update deployment image to ${NEW_IMAGE_NAME}' || echo 'No changes to commit'"
                        sh "git push https://${GITHUB_TOKEN}@github.com/${env.GIT_USER_NAME}/${env.GIT_REPO_NAME}.git HEAD:main --quiet"
                    }
                }
            }
        }
    }
}
