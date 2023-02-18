  --CREAR FUNCION clean_integer
CREATE OR REPLACE FUNCTION
  keepcoding.clean_integer (num_nulo INTEGER)
  RETURNS INTEGER AS ((
    SELECT
    IF
      (num_nulo IS NULL, -999999, num_nulo)));