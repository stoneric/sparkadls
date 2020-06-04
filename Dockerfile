FROM openjdk:8

ENV SPARK_DIST_FILENAME=spark-2.4.5-bin-without-hadoop
ENV HADOOP_DIST_FILENAME=hadoop-2.9.2
ENV SCALA_HOME=/usr/share/scala
ENV SPARK_HOME=/spark
ENV HADOOP_HOME=/hadoop
ENV SPARK_DIST_CLASSPATH=/hadoop/etc/hadoop:/hadoop/share/hadoop/common/lib/*:/hadoop/share/hadoop/common/*:/hadoop/share/hadoop/hdfs:/hadoop/share/hadoop/hdfs/lib/*:/hadoop/share/hadoop/hdfs/*:/hadoop/share/hadoop/mapreduce/lib/*:/hadoop/share/hadoop/mapreduce/*:/hadoop/share/hadoop/yarn:/hadoop/share/hadoop/yarn/lib/*:/hadoop/share/hadoop/yarn/*:/hadoop/share/hadoop/tools/lib/*:/hive/lib/*

ENV PATH=$PATH:$SPARK_HOME/bin:$SCALA_HOME/bin

    
RUN cd /tmp && wget --no-verbose http://apache.mirror.iweb.ca/spark/spark-2.4.5/$SPARK_DIST_FILENAME.tgz && \
    tar -xzf $SPARK_DIST_FILENAME.tgz && \
    mv $SPARK_DIST_FILENAME /spark

RUN cd /tmp && wget --no-verbose https://www-eu.apache.org/dist/hadoop/common/$HADOOP_DIST_FILENAME/$HADOOP_DIST_FILENAME.tar.gz && \
    tar -zxf $HADOOP_DIST_FILENAME.tar.gz && \
    mv $HADOOP_DIST_FILENAME /hadoop
    
RUN cd /tmp && wget --no-verbose  https://repo1.maven.org/maven2/org/apache/spark/spark-hive_2.11/2.4.5/spark-hive_2.11-2.4.5.jar && \
    mv ./spark-hive_2.11-2.4.5.jar $SPARK_HOME/jars 

RUN cd /tmp && wget --no-verbose  https://repo1.maven.org/maven2/org/apache/spark/spark-hive-thriftserver_2.11/2.4.5/spark-hive-thriftserver_2.11-2.4.5.jar && \
    mv ./spark-hive-thriftserver_2.11-2.4.5.jar $SPARK_HOME/jars

RUN cd /tmp && wget --no-verbose http://apache.mirror.rafal.ca/hive/hive-1.2.2/apache-hive-1.2.2-bin.tar.gz && \
    tar -zxf apache-hive-1.2.2-bin.tar.gz && \
    mv apache-hive-1.2.2-bin /hive

ENV SPARK_DIST_CLASSPATH=$SPARK_DIST_CLASSPATH:/hive/lib/* 

RUN rm -rf /tmp/*

RUN useradd -u 1002 spark

RUN chmod go+wr /tmp
RUN chown spark:spark /opt

USER spark

WORKDIR /opt

CMD [ "bash" ]
