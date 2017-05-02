# s2i-gs-spring-boot-docker
#FROM openshift/base-centos7
FROM ubuntu:16.04

# TODO: Put the maintainer name in the image metadata
MAINTAINER Amit Bondwal <amit.bondwal@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-oracle

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
#LABEL io.k8s.description="Platform for building xyz" \
#      io.k8s.display-name="builder x.y.z" \
#      io.openshift.expose-services="8080:http" \
#      io.openshift.tags="builder,x.y.z,etc."

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
#RUN yum install -y rubygems && yum clean all -y
#RUN gem install asdf
## Remove any existing JDKs
RUN apt-get --purge remove openjdk*

## Install Oracle's JDK
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update && \
  apt-get install -y --no-install-recommends oracle-java8-installer gradle && \
  apt-get clean all



RUN apt-get update && apt-get install gradle -y

RUN mkdir /usr/share/bayboon
# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/
RUN echo $PWD
#WORKDIR /usr/share/bayboon
RUN sh -c 'touch /app.jar'
RUN echo $PWD
# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image 
# sets io.openshift.s2i.scripts-url label that way, or update that label
LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i
COPY ./s2i/bin/ /usr/local/s2i

# TODO: Set the default port for applications built using this image
EXPOSE 8080
# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
#USER 1001



# TODO: Set the default CMD for the image
 #CMD ["usage"]
