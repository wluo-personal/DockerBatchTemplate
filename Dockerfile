###########
# BUILDER #
###########

# Base Image
FROM python:3.7 as builder
# TOKEN is for github authentification usage
ARG TOKEN
ARG project='dockerbatchtemplate'

RUN apt-get update && \
    apt-get -y install sudo git curl &&\
    mkdir /root/${project}

COPY ${project} /root/${project}/${project}
COPY pyproject.toml /root/${project}/


RUN git config --global --add url."https://${TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/" && \
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python && \
    cd /root/${project}/${project} && $HOME/.poetry/bin/poetry install && mkdir /wheels && \
    $HOME/.poetry/bin/poetry export -f requirements.txt --without-hashes > requirements.txt && \
    pip wheel --no-cache-dir --no-deps --wheel-dir /wheels -r requirements.txt && \
    $HOME/.poetry/bin/poetry build && \
    cp /root/${project}/dist/*.whl /wheels


#########
# FINAL #
#########

# Base Image
FROM python:3.7-slim-buster
MAINTAINER wluo-personal "luoweiforever@gmail.com"

# Install lib required
RUN apt-get update && \
    apt-get -y install sudo vim libpq-dev awscli

# Set timezone
ENV TZ=America/New_York



# Install Requirements
COPY  --from=builder /wheels /wheels
COPY  --from=builder /etc/localtime /etc/localtime
COPY  --from=builder /etc/timezone /etc/timezone

RUN pip install --upgrade pip && pip install --no-cache /wheels/*

WORKDIR /root

# Change to the app user
ENTRYPOINT ["cli"]
CMD ["--help"]