#!/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS="../../.credential/doctorcha-ai.json"
export PROJECT_NAME=task_text_header
export PORT=7000
export ML_BACKEND_URL="http://localhost:7080"

label-studio start ${PROJECT_NAME} --init -b --host 0.0.0.0 --port ${PORT} \
--ml-backend ${ML_BACKEND_URL} \
--username dingbro --password qwer1234 \
-l config.xml \
--source gcs --source-path text-header-dataset \
--source-params "{\"use_blob_urls\": true, \"prefix\": \"images2\", \"regex\": \"^.*.(jpeg|jpg|JPG|JPEG)\" }" \
-c project_config.json \
--sampling uniform \
--log-level INFO \
--force \
--target gcs-completions --target-path text-header-dataset \
--target-params "{\"prefix\": \"outputs2\"}" \
--use-gevent



# --input-path=tasks \ 
# --input-format=json-dir \

# --source gcs --source-path text-header-dataset \
# --source-params "{\"use_blob_urls\": true, \"data_key\": \"image\", \"prefix\": \"images1\", \"regex\": \"^.*.(jpeg|jpg|JPG|JPEG)\" }" \