#!/bin/bash

project_number=$1
echo $project_number


export GOOGLE_APPLICATION_CREDENTIALS="../../.credential/doctorcha-ai.json"
export PROJECT_NAME="task_text_header${project_number}"
export PORT="70${project_number}"
export ML_BACKEND_URL="http://localhost:7070"

source_prefix="partition/t${project_number}"
target_prefix="partition/r${project_number}" 

label-studio start ${PROJECT_NAME} --init -b --host 0.0.0.0 --port ${PORT} \
--ml-backend ${ML_BACKEND_URL} \
--username dingbro --password qwer1234 \
-l config.xml \
--source gcs --source-path text-header-dataset \
--source-params "{\"use_blob_urls\": false, \"prefix\": \"${source_prefix}\", \"regex\": \"^.*.json\" }" \
-c project_config.json \
--sampling sequential \
--log-level INFO \
--force \
--target gcs-completions --target-path text-header-dataset \
--target-params "{\"prefix\": \"${target_prefix}\", \"create_local_copy\": false}" \
--use-gevent

# --input-path=tasks \ 
# --input-format=json-dir \

# --source gcs --source-path text-header-dataset \
# --source-params "{\"use_blob_urls\": true, \"data_key\": \"image\", \"prefix\": \"images1\", \"regex\": \"^.*.(jpeg|jpg|JPG|JPEG)\" }" \