--CREAR TABLA ivr_summary.
CREATE OR REPLACE TABLE
  keepcoding. ivr_summary AS
SELECT
  A.ivr_id,
  A.phone_number,
  A.ivr_result,
  A.start_date,
  A.end_date,
  A.total_duration,
  A.customer_segment,
  A.ivr_language,
  A.steps_module,
  A.module_aggregation,
  IFNULL(MAX(NULLIF(A.document_type,'NULL')), 'DESCONOCIDO') AS document_type,
  IFNULL(MAX(NULLIF(A.document_identification,'NULL')), 'DESCONOCIDO') AS document_identification,
  IFNULL(MAX(NULLIF(A.customer_phone,'NULL')), 'DESCONOCIDO') AS customer_phone,
  IFNULL(MAX(NULLIF(A.billing_account_id,'NULL')), 'DESCONOCIDO') AS billing_account_id,
  MAX(
  IF
    (A.module_name = 'AVERIA_MASIVA',1, 0)) AS masiva_lg,
  MAX(
  IF
    (A.step_name = 'CUSTOMERINFOBYPHONE.TX'
      AND A.step_description_error = 'NULL', 1, 0)) AS info_by_phone_lg,
  MAX(
  IF
    (A.step_name = 'CUSTOMERINFOBYDNI.TX'
      AND A.step_description_error = 'NULL', 1, 0)) AS info_by_dni_lg,
  MAX(
  IF
    (TIMESTAMP_DIFF(A.start_date,B.start_date,SECOND) BETWEEN 0
      AND 86400, 1, 0 )) AS repeated_phone_24H,
  MAX(
  IF
    (TIMESTAMP_DIFF(B.start_date,A.start_date,SECOND) BETWEEN 0
      AND 86400, 1, 0 )) AS cause_recall_phone_24H,
  CASE
    WHEN A.vdn_label LIKE 'ATC%' THEN 'FRONT'
    WHEN A.vdn_label LIKE 'TECH%' THEN 'TECH'
    WHEN A.vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
  ELSE
  'RESTO'
END
  AS vdn_aggregation
FROM
  keepcoding.ivr_detail A
LEFT JOIN
  keepcoding.ivr_detail B
ON
  A.phone_number = B.phone_number
  AND A.ivr_id <> B.ivr_id
GROUP BY
  A.ivr_id,
  A.phone_number,
  A.ivr_result,
  A.start_date,
  A.end_date,
  A.total_duration,
  A.customer_segment,
  A.ivr_language,
  A.steps_module,
  A.module_aggregation,
  vdn_aggregation
