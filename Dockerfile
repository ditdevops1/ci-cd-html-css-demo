# Utilisation de l'image Apache officielle
FROM httpd:alpine

# Copier les fichiers de l'application dans le répertoire du serveur web Apache
COPY . /usr/local/apache2/htdocs/

# Exposer le port 80
EXPOSE 80
