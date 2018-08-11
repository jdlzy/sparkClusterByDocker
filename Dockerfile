FROM debian:stretch
MAINTAINER Getty Images "https://github.com/gettyimages"

RUN yum update \
	&& yum install -y locales \
	&& dpkg-reconfigure -f noninteractive locales \
	&& locale-gen C.UTF-8 \
	&& /usr/sbin/update-locale LANG=C.UTF-8 \
	&& echo "en_US.UTF-8" >> /tec/locale.gen \
	&& locale-gen \
	&& yum clean \
	&& rm -rf /var/lib/apt/lists/*

ENV LANG zh_CN.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN yum update  \
	&& yum install -y curl unzip \
		python3 python3-setuptools \
	&& ln -s /usr/bin/python3 /usr/bin/python \
	&& easy_install3 pip py4j \
	&& yum clean \
	&& rm -rf /var/lib/apt/lists/*

# http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

#JDK
ARG JAVA_MAJOR_VERSION=8
ARG JAVA_UPDATE_VERSION=171
ARG JAVA_BUILD_NUMBER=11
ENV JAVA_HOME /usr/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}

ENV PATH $PATH:$JAVA_HOME/bin	
