  --CREAR TABLA ivr_detail.
CREATE OR REPLACE TABLE
  keepcoding.ivr_detail AS
SELECT
  cl.ivr_id,
  cl.phone_number,
  cl.ivr_result,
  cl.vdn_label,
  cl.start_date,
  FORMAT_DATE('%Y%m%d',cl.start_date) AS start_date_id,
  cl.end_date,
  FORMAT_DATE('%Y%m%d',cl.end_date) AS end_date_id,
  cl.total_duration,
  cl.customer_segment,
  cl.ivr_language,
  cl.steps_module,
  cl.module_aggregation,
  md.module_sequece,
  md.module_name,
  md.module_duration,
  md.module_result,
  st.step_sequence,
  st.step_name,
  st.step_result,
  st.step_description_error,
  st.document_type,
  st.document_identification,
  st.customer_phone,
  st.billing_account_id
FROM
  keepcoding.ivr_calls cl
LEFT JOIN
  keepcoding.ivr_modules md
ON
  cl.ivr_id = md.ivr_id
LEFT JOIN
  keepcoding.ivr_steps st
ON
  md.ivr_id = st.ivr_id
  AND md.module_sequece = st.module_sequece