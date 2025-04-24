FROM mysql:8
ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=app_db
COPY init.sql /docker-entrypoint-initdb.d/
EXPOSE 3306