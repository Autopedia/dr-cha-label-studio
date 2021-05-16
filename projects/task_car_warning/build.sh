cd ../../

export PROJECT_NAME=task_car_warning
export PROJECT_ID=doctorcha-ai
export HOSTNAME=asia.gcr.io

export PORT=5000
export GOOGLE_APPLICATION_CREDENTIALS="doctorcha-ai-3a236e79d498.json"

mkdir temp
cp ./projects/${PROJECT_NAME}/docker-entrypoint.sh temp/docker-entrypoint.sh
cp ./projects/${PROJECT_NAME}/config.xml temp/config.xml
cp ./projects/${PROJECT_NAME}/project_config.json temp/project_config.json
cp ./.credential/${GOOGLE_APPLICATION_CREDENTIALS} temp/${GOOGLE_APPLICATION_CREDENTIALS}

docker-compose up -d # --build

echo "\n========================================"
echo "Server running at http://0.0.0.0:${PORT}"
echo "========================================\n"

rm -rf temp