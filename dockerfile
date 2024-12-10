# FROM huggingface/transformers-pytorch-gpu
FROM pytorch/pytorch:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul
ADD ./workspace /opt/workspace
WORKDIR /opt/workspace

# Latest version of transformers-pytorch-gpu seems to lack tk. 
# Further, pip install fails, so we must upgrade pip first.
RUN cd /etc/apt && \
    sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' sources.list
RUN apt-get -y update
RUN apt-get -y install python3-tk git vim curl
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"
RUN uv self update

COPY requirements.txt .
# RUN python3 -m pip install -r requirements.txt
RUN uv pip install -r requirements.txt --system

# To be able to see logs in real time
ENV PYTHONUNBUFFERED=1


# ENTRYPOINT ["python3"]
# CMD ["app.py", "--server_name", "0.0.0.0", "--auto_parallel", "True"]