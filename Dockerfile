from jupyter/datascience-notebook:ubuntu-18.04
USER root
RUN sudo apt-get update && sudo apt-get install -y python-dev libmysqlclient-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
