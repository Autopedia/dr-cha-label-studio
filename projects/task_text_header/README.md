# Waddle's Text Header Classification  

## 1. Google Cloud Storage Setup

안정성 있는 데이터 라벨링 진행을 위해서는 원본 데이터셋을 클라우드 스토리지 상에 업로드 한 후 진행하는  것이 바람직합니다. 본 프로젝트에서 라벨링에 사용한 `label-studio`는 클라우드 스토리지(GCS, S3)에 업로드 되어 있는 이미지를 불러와 작업자에게 보여주고 작업자가 제출한 결과 또한 클라우드 출력 폴더에 저장하는 기능을 제공하고 있습니다.  

이러한 기능을 활용한다면 추후 `label-studio`를 운영하는 서버가 다운되더라도 재가동시에 기존에 작업 중이던 시점부터 바로 재개할 수 있어 용이합니다. 또한 로컬 환경에 데이터셋을 저장하는 것보다 훨씬 안정적이며 라벨링 중간 중간 데이터셋을 바로 활용하기에 적합합니다.  

본 문서에서는 구글 클라우드 스토리지(GCS)를 사용하여 GCS credential을 발급하고 GCS 폴더에 이미지셋을 업로드하는 과정을 보여드립니다.  


### GCP 크레덴셜 발급  

1. [GCS Client Library](https://cloud.google.com/storage/docs/reference/libraries)를 참조하여 로컬 환경에 `google-cloud-storage`를 설치해줍니다.  

2. [서비스 계정 키 만들기 페이지](https://console.cloud.google.com/apis/credentials/serviceaccountkey?_ga=2.4468659.1245984618.1601916851-2009446239.1599184222&_gac=1.153742026.1599188803.CjwKCAjwqML6BRAHEiwAdquMnWXeL5XPuyYzWEHktAYDFyDbqsuT8ELRGsa1QyLYenFno0ooNXps_BoCotMQAvD_BwE)에서 programmatic한 엑세스를 위한 json 형태의 계정키를 발급합니다. 

3. 생성한 `<project-name>-<id>.json`을 `projects/task-text-header`에 위치시킵니다.  


### 이미지 데이터셋 업로드  

1. GCS 콘솔 상에서 `text-header-dataset`의 이름으로 버킷 생성을 한 후 위치 유형은 예산 절약을 위해 `Region`으로 설정해줍니다.  

2. `text-header-dataset` 내에 `images1`, `jsons1`, `outputs1` 폴더를 생성해줍니다. 이때 `images1`은 전체 이미지셋을 업로드할 폴더, `jsons1`은 OCR 인식 결과를 담는 폴더, `outputs1`은 추후 `label-studio`에서 작업자가 제출한 어노테이션 결과가 저장되는 스토리지입니다. 

3. 기술1A의 데이터셋인 `data.zip`을 압축 해제 후 unboxed_image 내 이미지는 모두 `gs://text-header-dataset/images1` 내에 업로드하고 json_data 내 json 파일들은 모두 `gs://text-header-dataset/jsons1` 내에 업로드해줍니다. 

```
gsutil -m cp unbox_image_data/*.jpg gs://text-header-dataset/images1
gsutil -m cp json_data/*.json gs://text-header-dataset/jsons1
```

## 2.  Launch Label-Studio

데이터셋 구축은 `label-studio`를 활용합니다.  
특히 `label-studio`에서 클라우드 스토리지와의 연동은 [여기](https://labelstud.io/guide/storage.html)를 참조해주시면 됩니다. 

신규 프로젝트를 생성하기 위해서는 

## 3. Launch Label-Studio ML Backend  

OCR 인식을 통한 텍스트 박스를 라벨링 시에 표시하기 위해서 ML Backend 기능을 활용합니다. 
`rectangle_ml_backend`는 주어진 이미지의 파일명을 바탕으로 `gs://text-header-dataset/jsons1` 내에서 `json` 데이터를 들고 온 후 text box들의 좌표를 추출하여 `label-studio`의 요청에 반환해줍니다.  

아래 명령어를 통해서 백엔드 프로세스를 실행시킬 수 있습니다. 

```
$ cd projects/task_text_header  
$ label-studio-ml start rectangle_ml_backend
```

## 3. Model Training  