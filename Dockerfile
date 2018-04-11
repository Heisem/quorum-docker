FROM ubuntu:16.04

RUN apt-get update -y \
    && apt-get install -y git wget build-essential software-properties-common supervisor nginx \
    && mkdir -p /logs

ADD ./ /home

## Supervisor
ADD custom-init/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

## nginx
RUN useradd --no-create-home nginx
ADD custom-init/nginx.conf /etc/nginx/nginx.conf

RUN /home/custom-init/bootstrap.sh

WORKDIR /home/examples/7nodes

RUN ./raft-init.sh
# RUN ./raft-start.sh

EXPOSE 80 22000 22001 22002 22003 22004 22005 22006

CMD ["/usr/bin/supervisord"]