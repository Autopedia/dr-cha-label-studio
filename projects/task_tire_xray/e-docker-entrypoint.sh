#!/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS="../../.credential/dingbro-aichampionship.json"
export PROJECT_NAME=task_tire_xray_e
export PORT=8003

label-studio start ${PROJECT_NAME} --init -b --host 0.0.0.0 --port ${PORT} \
--username dingbro --password qwer1234 \
-l e-config.xml \
-c project_config.json \
--sampling sequential \
--log-level INFO \
--force \
--source gcs --source-path hankooktier \
--source-params "{\"use_blob_urls\": true, \"data_key\": \"image\", \"prefix\": \"data4ls_e_images\", \"regex\": \"^.*.(jpeg|jpg|JPG|JPEG)\" }" \
--target gcs-completions --target-path hankooktier \
--target-params "{\"prefix\": \"data4ls_e_outputs_3\", \"create_local_copy\": false}" \
--use-gevent