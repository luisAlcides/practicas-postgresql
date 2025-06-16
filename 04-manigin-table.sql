-- (Ejecuta esto como superusuario o como postgres)
CREATE DATABASE testdb2;


-- 2.1 Tabla que usaremos para fuente de datos
CREATE TABLE numbers (
  n INT PRIMARY KEY
);

-- 2.2 Insertar valores del 1 al 10
INSERT INTO numbers
SELECT generate_series(1,10);


-- buble
CREATE OR REPLACE FUNCTION demo_loop_conditional()
  RETURNS VOID AS
$$
DECLARE
  rec RECORD;
BEGIN
  RAISE NOTICE 'Total de filas en numbers: %', (SELECT COUNT(*) FROM numbers);
  FOR rec IN SELECT n FROM numbers LOOP
    IF (rec.n % 2) = 0 THEN
      RAISE NOTICE '% es PAR', rec.n;
    ELSE
      RAISE NOTICE '% es IMPAR', rec.n;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT demo_loop_conditional();

-- crear tabla temporal
CREATE TEMP TABLE temp_numbers (
  n INT
) ON COMMIT DELETE ROWS;



-- transaccion manual
BEGIN;
  INSERT INTO temp_numbers
    SELECT n FROM numbers WHERE n BETWEEN 1 AND 3;
  -- Comprueba cuántas filas hay antes del COMMIT:
  SELECT COUNT(*) AS antes_del_commit FROM temp_numbers;
COMMIT;
-- Tras el COMMIT, los datos han sido borrados:
SELECT COUNT(*) AS despues_del_commit FROM temp_numbers;



-- 2.1 Tabla que usaremos para fuente de datos
CREATE TABLE numbers (
  n INT PRIMARY KEY
);

-- 2.2 Insertar valores del 1 al 10
INSERT INTO numbers
SELECT generate_series(1,10);

-- Transaccion 2
BEGIN;
  INSERT INTO temp_numbers
    SELECT n FROM numbers WHERE n BETWEEN 4 AND 6;
  SELECT COUNT(*) FROM temp_numbers;
COMMIT;
SELECT COUNT(*) FROM temp_numbers;


-- transaccion 3
BEGIN;
  INSERT INTO temp_numbers
    SELECT n FROM numbers WHERE n BETWEEN 7 AND 10;
  SELECT COUNT(*) FROM temp_numbers;
COMMIT;
SELECT COUNT(*) FROM temp_numbers;

-- Ejercicio avanzado: loop en psql
\set start 1
\set end 3
\echo '== Iteración 1: insertar de :start a :end =='
BEGIN;
  INSERT INTO temp_numbers
    SELECT n FROM numbers WHERE n BETWEEN :start AND :end;
  \gset
  SELECT COUNT(*) AS inserted FROM temp_numbers;
COMMIT;
SELECT COUNT(*) AS after_commit FROM temp_numbers;

-- actualiza rangos
\set start 4
\set end 6

\echo '== Iteración 2: insertar de :start a :end =='
BEGIN;
  INSERT INTO temp_numbers
    SELECT n FROM numbers WHERE n BETWEEN :start AND :end;
  SELECT COUNT(*) FROM temp_numbers;
COMMIT;
SELECT COUNT(*)


-- unlogged TABLE
CREATE UNLOGGED TABLE unlogged_users (
pk INT GENERATED ALWAYS AS IDENTITY,
username TEXT NOT NULL,
gecos TEXT,
email TEXT NOT NULL,
PRIMARY KEY (pk),
UNIQUE (username)
)
