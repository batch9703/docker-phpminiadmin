# docker-phpminiadmin
smallest database management tool on docker.  
docker execute phpminiadmin.  
phpminiadmin with env parameter.  
If you are not in Japan, change the "TZ" and "LANG" of the Dockerfile and then "docker build" again.
## ENV parameter
* `ACCESS_PWD`: Access password. No password if not set.
* `DB_HOST`: Database host name.
* `DB_PORT`: Database port no. "3306" if not set.
* `DB_NAME`: Database name
* `DB_USER`: Database user
* `DB_PASSWORD`: Database password
