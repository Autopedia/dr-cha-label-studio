


### 초기 계정을 생성 및 credential 분리 프로젝트 초기화  

`.env/test.env` 상에 초기 사용자의 크레덴셜 정보, 포트, 도메인 정보를 입력함.

```env
LABEL_STUDIO_USERNAME_ENV="email"
LABEL_STUDIO_PASSWORD_ENV="password"
PORT_ENV=8501
LABEL_STUDIO_HOST_ENV="http://on-premise.doctor-cha.com:${PORT_ENV}/"
```


`docker-compose.yml` 상에서 nginx와 app을 위한 포트를 설정해주고 `LABEL_STUDIO_DISABLE_SIGNUP_WITHOUT_LINK`, `LABEL_STUDIO_HOST` 와 같은 환경변수도 지정해준다. 이 때 주의사항으로는 절대 app의 환경변수에 `PORT`를 별도로 지정하면 안된다. nginx에서 관리하기 때문에 label studio는 항상 8080 포트를 listen하고 있어야 함.  

| 주의사항. 꼭 공유기 상에서 포트 포워딩을 지정하도록 하자  

```yaml
  nginx:
    image: nginx:latest
    ports:
      - ${PORT_ENV}:80
    depends_on:
      - app
    volumes:
      - static:/label-studio/label_studio:rw
      - ./mydata:/label-studio/data:rw
      - ./deploy/nginx/${NGINX_FILE:-default.conf}:/etc/nginx/conf.d/default.conf:ro
    command: nginx -g "daemon off;"

  app:
    stdin_open: true
    tty: true
    build: .
    image: heartexlabs/label-studio:latest
    expose:
      - ${PORT_ENV}
    depends_on:
      - db
    environment:
      - DJANGO_DB=default
      - POSTGRE_NAME=postgres
      - POSTGRE_USER=postgres
      - POSTGRE_PASSWORD=
      - POSTGRE_PORT=5432
      - POSTGRE_HOST=db
      - LABEL_STUDIO_HOST=${LABEL_STUDIO_HOST_ENV:-""}
      - LABEL_STUDIO_USERNAME=${LABEL_STUDIO_USERNAME_ENV}
      - LABEL_STUDIO_PASSWORD=${LABEL_STUDIO_PASSWORD_ENV}
      - GOOGLE_APPLICATION_CREDENTIALS=./dingbro-ai-storage.json
      - LABEL_STUDIO_DISABLE_SIGNUP_WITHOUT_LINK=true
    volumes:
      - ./mydata:/label-studio/data:rw
      - static:/label-studio/label_studio:rw
    command: [ "./deploy/wait-for-postgres.sh", "db", "bash", "/label-studio/deploy/start_label_studio.sh" ]

```

`docker-compose.yml` environment 상에서 명시하는 것은 효과가 없었으며 `start_label_studio.sh`에 직접 argument로 명시해야만 작동함. 그래서 환경변수를 다시 인자로 넘겨줌

```bash
label-studio start --username $LABEL_STUDIO_USERNAME --password $LABEL_STUDIO_PASSWORD
```  

### Danger Zone 제거하기 


### Start Project

아래 명령어를 통해서 `.env` 파일이 정상적으로 `docker-compose.yml`에서 치환되는지 확인할 수 있다.  
```bash
sudo docker-compose -p trash --env-file .env/test.env config
```

아래 명령어를 통해서 LS 도커 컨테이너를 실행시킬 수 있음. 백그라운드 실행을 원한다면 `-d` 옵션을 붙여주자.   
```bash
sudo docker-compose -p trash --env-file .env/test.env up --build 
```

### Terminate Project  
아래 명령을 입력해야 볼륨과 네트워크까지 자동으로 삭제됨. 
두번째 줄을 실행해야 DB 정보 (계정, 프로젝트) 등이 삭제됨.  

```bash
sudo docker-compose -p trash --env-file .env/test.env  down --volumes
sudo rm -rf postgres-data/
```
