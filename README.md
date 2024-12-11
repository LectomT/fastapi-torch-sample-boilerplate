# FastAPI Torch Boilerplate

## 개요

### 목적
* 빈번하게 사용되는 FastAPI로 Wrapping한 PyTorch의 도커 환경을 미리 셋팅해서 손쉽게 새로운 프로젝트를 시작 할 수 있도록 한다.

### 특징
* 컨테이너로 패키징 되는 구조임으로 동시에 다양한 환경을 구현할 수 있으며, 배포가 용이하다.

### 활용법

## 사용하기

### 준비사항
* Docker Core Enginge 혹은 Docker와 호환되는 컨테이너 도구가 설치된 머신

### 파일트리구조

```
torch-base-boilerplate
 ┣ workspace
 ┃ ┣ docs*
 ┃ ┣ src
 ┃ ┣ tests
 ┃ ┣ api.py*
 ┃ ┣ app.py*
 ┃ ┣ config.json5
 ┃ ┗ option.py^
 ┣ .env^
 ┣ .gitattributes
 ┣ .gitignore^
 ┣ docker-compose.yml*
 ┣ dockerfile*
 ┗ requirements.txt*
```
* '*'는 필수 항목, ^는 권장항목
* workspace 이하 항목은 컨테이너 내부의 /opt/workspace 경로에 동적으로 마운트된다. (docker-compose.yml 참조)

### 빌드
' docker compose build '
> dockerfile상 변화가 없으나 디펜던시 변화 등으로 재빌드가 필요할 때는 --no-cache 옵션을 주어 캐시를 이용하지 않고 재빌드를 할 수 있도록 한다.


### 실행
' docker compose up '
* docker-compose.yml의 'entrypoint: uvicorn api:app --host 0.0.0.0 --port 7890 --reload' 구문이 실행지점

### 환경 관리
최신 버전 활용이 원칙이나 requirements.txt 에 버전을 픽스하는 방식으로도 사용할 수 있다. 프로덕션 배포는 Docker Image에 Commit해서 유지하길 권장
  
## 부록
### 베어메탈에 도커 설치하기
```
#Ubuntu 24.04.1 기준
sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin python3-pip
sudo usermod -aG docker $USER
```
* WSL상에 설치는 VSCode로 WSL에 리모트 연결한 상태에서 Extension 설치로도 가능하다

### Nvidia GPU 이용하기
```
$ curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
$ sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
```
> $nvidia-smi 로 GPU 인식을 확인한다.

### Ruff 설정
IDE를 다른 것을 사용할 수 있고 각각 vs code 설정은 다를 수 있으니
```
# settings.json
"[python]": {
        "editor.defaultFormatter": "charliermarsh.ruff",
        "editor.insertSpaces": true,
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
          "source.fixAll": "explicit",
          "source.organizeImports": "explicit",
          "editor.insertSpaces": "explicit"
        }
    }
```

```
# pyproject.toml
line-length = 120
indent-width = 4

[lint]
# 기본적으로 Pyflakes('F')와 pycodestyle('E') 코드의 하위 집합을 활성화합니다.
select = ["E4", "E7", "E9", "F"]
ignore = []

# 활성화된 모든 규칙에 대한 수정 허용.
fixable = ["ALL"]
unfixable = []

# 밑줄 접두사가 붙은 경우 사용하지 않는 변수를 허용합니다.
dummy-variable-rgx = "^(_+|(_+[a-zA-Z0-9_]*[a-zA-Z0-9]+?))$"

[format]
quote-style = "double"
indent-style = "space"
skip-magic-trailing-comma = false
line-ending = "auto"
docstring-code-format = false
docstring-code-line-length = "dynamic"
```