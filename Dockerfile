FROM debian:8

ENV DEBIAN_FRONTEND noninteractive
ENV PATH "$PATH:/opt/android_tools/android-ndk-r14b:/opt/android_tools/android-sdk-linux"

RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

RUN apt-get -y update && \
    apt-get -y install software-properties-common unzip tar curl openssh-server && \
    add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" && \
    apt-get update && \
    apt-get -y install oracle-java8-installer && \
    apt-get clean

USER root

RUN sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd
RUN adduser --quiet jenkins
RUN echo "jenkins:jenkins" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]




