FROM ubuntu:16.04
MAINTAINER romracer <romracer@gmail.com>

### ocfs2 ###
### requires kernel support from docker host ###
COPY ocfs2/set-selections.sh /tmp/
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y curl \
	&& echo 'deb http://download.opensuse.org/repositories/home:/romracer1/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/ocfs2-tools.list \
	&& curl -L 'http://download.opensuse.org/repositories/home:romracer1/xUbuntu_16.04/Release.key' | apt-key add - \
	&& sh -x /tmp/set-selections.sh \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y jq kmod parted ocfs2-tools \
	&& apt-get purge -y curl && apt-get autoremove --purge -y && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN dpkg-reconfigure -fnoninteractive ocfs2-tools

COPY storage /usr/bin/
COPY ocfs2/rancher-ocfs2 common/* /usr/bin/
CMD ["start.sh", "storage", "--driver-name", "rancher-ocfs2"]
