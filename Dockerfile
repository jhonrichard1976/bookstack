# Dockerfile personalizado para BookStack en OpenShift

# Utiliza la imagen base proporcionada desde Docker Hub
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

    # Configurar los cifradores fuertes para SSL/TLS en Apache
RUN echo "SSLCipherSuite HIGH:!aNULL:!MD5:!3DES" >> /etc/apache2/mods-available/ssl.conf && \
    echo "SSLProtocol all -SSLv2 -SSLv3" >> /etc/apache2/mods-available/ssl.conf && \
    echo "SSLHonorCipherOrder on" >> /etc/apache2/mods-available/ssl.conf

# Deshabilitar el método TRACE en Apache
RUN echo "TraceEnable off" >> /etc/apache2/apache2.conf

# Configurar PHP para no exponer la versión
RUN echo "expose_php = Off" > /usr/local/etc/php/conf.d/security.ini

# Eliminar encabezado X-Powered-By desde Apache
RUN apt-get update && apt-get install -y apache2 && \
    echo 'Header unset X-Powered-By' >> /etc/apache2/apache2.conf && \
    a2enmod headers

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
