// Déclaration du pipeline Jenkins
pipeline {
    // Exécute le pipeline sur n'importe quel agent
    agent any

    // Variables d'environnement globales
    environment {
        DOCKER_IMAGE = "${DOCKER_USERNAME}/webinaire-app:${IMAGE_VERSION}"  // Nom de l'image Docker à construire
        DOCKER_USERNAME = "ditdevops1"  // Nom d'utilisateur Docker Hub
        DOCKER_CONTAINER = "ci-cd-html-css-app"  // Nom du conteneur à déployer
        DOCKER_CREDENTIALS = credentials("c51aa3f7-82ee-4b60-828c-376f73dd3951")  // Identifiants Docker Hub
        IMAGE_VERSION = "1.${BUILD_NUMBER}"  // Version dynamique basée sur le numéro de build Jenkins

    }

    // Étapes du pipeline
    stages {
        // Étape 1 : Récupération du code source depuis GitHub
        stage("Checkout") {
            steps {
                // Clone la branche 'master' du dépôt Git
                git branch: 'master', url: 'https://github.com/ditdevops1/ci-cd-html-css-demo.git'
            }
        }

        // Étape 2 : Exécution des tests unitaires
        stage("Test") {
            steps {
                script {
                    // Configure un environnement et exécute les tests

                    echo "test en cours"
                }
            }
        }

        // Étape 3 : Construction de l'image Docker
        // si vous travaillez sur windows , utliser bat et sur linux utiliser sh
        stage("Build") {
            steps {
                script {
                    // Construit l'image Docker
                    bat "docker build -t $DOCKER_IMAGE ."
                }
            }
        }

        // Étape 4 : Déploiement
        stage("Deploy") {
            steps {
                script {
                    // Connexion à Docker Hub
                    bat """
                        # Authentifie le Docker daemon local avec les identifiants Jenkins
                        docker login -u ${DOCKER_CREDENTIALS_USR} -p ${DOCKER_CREDENTIALS_PSW}
                        echo 'Docker login successful'
                    """

                    // Publication de l'image sur Docker Hub
                    bat """
                        # Pousse l'image vers Docker Hub
                        docker push $DOCKER_IMAGE
                    """

                    // Déploiement de l'application 
                    bat """
                        # Arrête le conteneur s'il existe
                        docker stop $DOCKER_CONTAINER || true
                        # Supprime le conteneur s'il  existe
                        docker rm $DOCKER_CONTAINER || true
                        # Lance un nouveau conteneur en mode détaché
                        docker run -d --name $DOCKER_CONTAINER -p 8080:80 $DOCKER_IMAGE
                    """
                }
            }
        }
    }
    post {
        success {
            emailext(
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """<p>SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                            <p>Deployed image: $DOCKER_USERNAME/webinaire-app:${IMAGE_VERSION}</p>
                            <p>Check console output at <a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
                to: 'ditdevops1@gmail.com',
                mimeType: 'text/html'
            )
        }
        failure {
            emailext(
                subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """<p>FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                            <p>Check console output at <a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
                to: 'ditdevops1@gmail.com',
                mimeType: 'text/html'
            )
        }
    }
}