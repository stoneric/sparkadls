FROM openjdk:8

ENV SPARK_DIST_FILENAME=spark-2.4.5-bin-without-hadoop
ENV HADOOP_DIST_FILENAME=hadoop-3.2.1
ENV SCALA_VERSION=2.12.8
ENV SCALA_HOME=/usr/share/scala
ENV SPARK_HOME=/spark
ENV HADOOP_HOME=/hadoop
ENV SPARK_DIST_CLASSPATH=/hadoop/etc/hadoop:/hadoop/share/hadoop/common/lib/*:/hadoop/share/hadoop/common/*:/hadoop/share/hadoop/hdfs:/hadoop/share/hadoop/hdfs/lib/*:/hadoop/share/hadoop/hdfs/*:/hadoop/share/hadoop/mapreduce/lib/*:/hadoop/share/hadoop/mapreduce/*:/hadoop/share/hadoop/yarn:/hadoop/share/hadoop/yarn/lib/*:/hadoop/share/hadoop/yarn/*:/hadoop/share/hadoop/tools/lib/*

ENV PATH=$PATH:$SPARK_HOME/bin:$SCALA_HOME/bin:$HADOOP_HOME/bin


RUN cd /tmp && \
    wget --no-verbose --no-check-certificate "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/"
    
RUN cd /tmp && wget --no-verbose http://apache.mirror.iweb.ca/spark/spark-2.4.5/$SPARK_DIST_FILENAME.tgz && \
    tar -xzf $SPARK_DIST_FILENAME.tgz && \
    mv $SPARK_DIST_FILENAME /spark

RUN cd /tmp && wget --no-verbose https://www-eu.apache.org/dist/hadoop/common/$HADOOP_DIST_FILENAME/$HADOOP_DIST_FILENAME.tar.gz && \
    tar -zxf $HADOOP_DIST_FILENAME.tar.gz && \
    mv $HADOOP_DIST_FILENAME /hadoop
    
RUN rm -rf /tmp/*

RUN useradd -u 1002 spark
USER spark

CMD [ "bash" ]
