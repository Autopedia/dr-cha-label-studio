#!/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS="../../.credential/dingbro-aichampionship.json"
export PROJECT_NAME=task_tire_xray_ah
export PORT=8001

label-studio start ${PROJECT_NAME} --init -b --host 0.0.0.0 --port ${PORT} \
--username dingbro --password qwer1234 \
-l ah-config.xml \
-c project_config.json \
--sampling sequential \
--log-level INFO \
--force \
--source gcs --source-path hankooktier \
--source-params "{\"use_blob_urls\": true, \"data_key\": \"image\", \"prefix\": \"data4ls_ah_images_2\", \"regex\": \"^.*.(jpeg|jpg|JPG|JPEG)\" }" \
--target gcs-completions --target-path hankooktier \
--target-params "{\"prefix\": \"data4ls_ah_outputs_2\", \"create_local_copy\": false}" \
--use-gevent