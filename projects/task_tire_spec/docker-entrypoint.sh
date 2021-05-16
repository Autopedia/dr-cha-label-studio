#!/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS="doctorcha-ai-3a236e79d498.json"

export PROJECT_NAME=task-tire-spec
export PORT=8000

label-studio start ${PROJECT_NAME} --init -b --host 0.0.0.0 --port ${PORT} \
--username dingbro --password qwer1234 \
-l config.xml \
-c project_config.json \
--sampling uniform \
--log-level INFO \
--force \
--source gcs --source-path tire-spec-dataset \
--source-params "{\"use_blob_urls\": true, \"data_key\": \"image\", \"prefix\": \"images1\", \"regex\": \"^.*.(jpeg|jpg|JPG|JPEG)\" }" \
--target gcs-completions --target-path tire-spec-dataset \
--target-params "{\"prefix\": \"outputs1\"}" 
# --use-gevent