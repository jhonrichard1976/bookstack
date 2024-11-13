# Dockerfile personalizado para BookStack en OpenShift

# Utiliza la imagen base proporcionada desde Quay
FROM minsal-registry-quay-quay-registry.apps.acm.minsal.cl/quayadmin/bookstack:24.10

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

# Exponer los puertos que se utilizan en el contenedor
EXPOSE 80 8080

# Comando para iniciar Apache en primer plano
CMD ["apachectl", "-D", "FOREGROUND"]
