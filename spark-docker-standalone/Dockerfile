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
RUN curl -sL --retry 3 --insecure \
	--header "Cookie: oraclelicense=accept-securebackup-cookie;" \
	"http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/512cd62ec5174c3487ac17c61aaa89e8/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz" \
	| gunzip \
	| tar x -C /usr/ \
	&& ln -s $JAVA_HOME /usr/java \
	&& rm -rf $JAVA_HOME/man

#Hadoop
ENV HADOOP_VERSION 3.0.0
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/hin
RUN curl -sL --retry 3 \
	"http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
	| gunzip \
	| tar -x -C /usr/ \
	&& rm -rf $HADOOP_HOME/share/doc \
	&& chown -R root:root $HADOOP_HOME

#Spark
ENV SPARK_VERSION 2.3.1
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -sL --retry 3 \
	"https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
	| gunzip \
	| tar x -C /usr/ \
	&& mv /usr/$SPARK_PACKAGE $SPARK_HOME \
	&& chown -R root:root $SPARK_HOME

WORKDIR $SPARK_HOME
CMD ["bin/spark-class","org.apache.spark.deploy.master.Master"]	
