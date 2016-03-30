FROM centos:6.7
MAINTAINER tomori <otarim.com@gmail.com>

#install devtools and deps
RUN yum -y groupinstall "Development Tools" tar xz which

#install node
ENV NODE_VERSION 5.0.0

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
	&& tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" \
	&& cd "node-v$NODE_VERSION-linux-x64/bin" \
	&& cp ./node /usr/local/sbin

#install npm and pm2
RUN curl https://www.npmjs.com/install.sh | npm_debug=1 clean=no PATH=$PATH sh \	
	&& npm install -g pm2

#install redis
RUN yum install -y gcc gcc-c++ kernel-devel
RUN curl -SLO http://download.redis.io/releases/redis-3.0.7.tar.gz \
	&& tar -xvf redis-3.0.7.tar.gz \
	&& cd redis-3.0.7 \
	&& make \
	&& make install \
	&& cd src \
	&& cp ./redis-server /usr/local/sbin \
	&& cp ./redis-cli /usr/local/sbin

#install mongo
RUN echo -e "[mongodb]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/6/mongodb-org/3.0/`uname -m`/\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/mongodb.repo
RUN yum install -y mongodb-org
RUN mongod --version

# install supervisord
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y python-pip && pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor

# add supervisord.conf
ADD conf/supervisord.conf /etc/
ADD run.sh /run.sh
RUN chmod a+x /run.sh 

EXPOSE 22 80 10090

CMD ["/bin/bash"]
