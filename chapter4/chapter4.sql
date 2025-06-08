# Creating new roles

# CREATE ROLE name WITH option ...

CREATE ROLE luca WITH LOGIN PASSWORD '123';
CREATE ROLE luca WITH LOGIN PASSWORD '123' VALID UNTIL '2025-12-25';

# crear roles que agrupan otros roles
CREATE ROLE book_authors WITH NOLOGIN;

# Asignar un role
GRANT ROLE book_authors TO luca;

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

