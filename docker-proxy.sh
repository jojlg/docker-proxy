# Créer le fichier docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3.7'

services:
  nginx-proxy:
    image: nginx:latest
    container_name: nginx-proxy    
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./conf.d:/etc/nginx/conf.d
      - ./ssl:/etc/nginx/ssl
    networks:
      - network-proxy-01

networks:
  network-proxy-01:
    external: true
EOL

# Créer et écrire dans le fichier nginx.conf
cat <<EOL > nginx.conf
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    include /etc/nginx/conf.d/*.conf;

    # Paramètres supplémentaires recommandés
    server_tokens off;
    client_max_body_size 64m;
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
}
EOL

# Créer le répertoire conf.d
mkdir -p conf.d

# Créer le fichier conf.d/http_redirect.conf
cat <<EOL > conf.d/http_redirect.conf
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name nom_du_serveur.domaine;

    location / {
        return 301 https://\$host\$request_uri;
    }
}
EOL

# Créer le répertoire ssl
mkdir -p ssl

echo "Configuration de nginx-proxy complétée avec succès."
