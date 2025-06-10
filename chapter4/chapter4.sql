# Creating new roles

# CREATE ROLE name WITH option ...

CREATE ROLE luca WITH LOGIN PASSWORD '123';
CREATE ROLE luca WITH LOGIN PASSWORD '123' VALID UNTIL '2025-12-25';

# crear roles que agrupan otros roles
CREATE ROLE book_authors WITH NOLOGIN;

# Asignar un role
GRANT book_authors TO luca;

# admin members
CREATE ROLE book_reviewers WITH NOLOGIN ADMIN luca;

GRANT book_reviewers TO juan WITH ADMIN OPTION;

# Removing an existing role
# DROP ROLE name
# DROP ROLE IF EXISTS


# Inspecting existing roles
SELECT current_role;

# If you connect to the database with another user, you will see different results
# psql -U user database


# pg_roles
SELECT rolname, rolcanlogin, rolconnlimit, rolpassword
FROM pg_roles
WHERE rolname = user

/*
1. rolname	Nombre del rol. Aquí siempre devolverá 'luca', pues lo filtras con WHERE rolname = 'luca'. Es el identificador del rol en el sistema.

2. rolcanlogin	Booleano (true/false): indica si ese rol puede iniciar sesión.
- true: el rol tiene permiso LOGIN (es decir, es un usuario al que puedes psql -U luca).
- false: es un rol de sólo grupo o sin permiso de conexión.

3. rolconnlimit	Límite de conexiones simultáneas que puede abrir ese rol.
- -1: sin límite (valor por defecto).
- ≥ 0: número máximo de conexiones.

4. rolpassword	Contraseña almacenada para el rol.
- Puede estar en texto cifrado (MD5 o SCRAM) o ser NULL:
- NULL suele significar que el rol usa otro método de autenticación (por ejemplo, peer).

rolname = luca: el nombre de tu rol.

rolcanlogin = t: puede iniciar sesión.

rolconnlimit = -1: no tiene límite de conexiones.

rolpassword = SCRAM-SHA-256$…: contraseña registrada en formato SCRAM.
* */


# Flujo para actualizar pg_hba.conf

# 1. Editar el archivo pg_hba.conf
# $EDITOR /etc/postgresql/16/main/pg_hba.conf
# 2. Recargar la configuración
# sudo -u postgres pg_ctl reload -D $PGDATA


/*
tipo	Cómo llega la conexión:
• local → socket UNIX (sin TCP/IP)
• host → TCP/IP sin SSL
• hostssl → TCP/IP con SSL

base_de_datos	A qué bases aplica la línea:
• nombre de una base específica
• all para todas
• también hay sameuser, samerole…

rol	Qué rol (usuario) debe usar:
• nombre de rol
• all para cualquier rol

origen	Desde dónde se conecta:
• IP o rango CIDR (192.168.1.0/24)
• hostname
• all, samehost, samenet

método_autenticación	Cómo se verifica la identidad:
• scram-sha-256, md5 → piden contraseña
• trust → permite sin contraseña (sólo testing)
• reject → siempre rechaza

*/

