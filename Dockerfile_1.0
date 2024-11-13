# Dockerfile personalizado para BookStack en OpenShift

# Utiliza la imagen base desde Docker Hub
FROM docker.io/rychy499/bookstack:latest

# Establecer variables de entorno necesarias para el despliegue
ENV APP_URL=https://bookstack-bookstack-pre.apps.prod.minsal.cl \
    DB_HOST=mysql \
    DB_DATABASE=bookstack \
    DB_USERNAME=bookstack \
    DB_PASSWORD=secret

# Configurar Apache para mejorar la seguridad
# Ocultar la version del servidor
RUN echo "ServerSignature Off" >> /etc/apache2/conf-available/security.conf && \
    echo "ServerTokens Prod" >> /etc/apache2/conf-available/security.conf && \
    a2enconf security

# Configurar los permisos para que Apache pueda escribir en los directorios necesarios
RUN chown -R www-data:www-data /var/www/bookstack && \
    chmod -R 755 /var/www/bookstack

# Agregar volúmenes para persistencia de datos
VOLUME /var/www/bookstack/public/uploads
VOLUME /var/www/bookstack/storage/uploads

# Exponer los puertos que se utilizan en el contenedor
EXPOSE 80 8080

# Comando para iniciar Apache en primer plano
CMD ["apachectl", "-D", "FOREGROUND"]
