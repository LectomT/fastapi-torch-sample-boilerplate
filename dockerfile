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
RUN python3 -m pip install --upgrade pip


COPY requirements.txt .
RUN python3 -m pip install -r requirements.txt

# To be able to see logs in real time
ENV PYTHONUNBUFFERED=1


# ENTRYPOINT ["python3"]
# CMD ["app.py", "--server_name", "0.0.0.0", "--auto_parallel", "True"]