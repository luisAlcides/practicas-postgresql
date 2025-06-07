SELECT current_date;
SELECT current_time;
SELECT current_role;

#crear usuario
# sudo -u postgres createuser --interactive

# Crear base datos con createdb
# sudo -u postgres createdb user


# postgresql://username@host:port/database 
# settings ls -l /etc/postgresql/16/main


# Permiter conexiones externas
# Editar postgresql.conf
# listen_address = '*'
# reiniciar servidor: sudo systemctl restart postgresql
