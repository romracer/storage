FROM ubuntu:16.04
MAINTAINER romracer <romracer@gmail.com>

### ocfs2 ###
### requires kernel support from docker host ###
COPY ocfs2/set-selections.sh /tmp/
RUN sh /tmp/set-selections.sh \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y jq kmod parted ocfs2-tools \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN dpkg-reconfigure -fnoninteractive ocfs2-tools

COPY storage /usr/bin/
COPY ocfs2/rancher-ocfs2 common/* /usr/bin/
CMD ["start.sh", "storage", "--driver-name", "rancher-ocfs2"]
