FROM openjdk:8-jdk

ARG user=jenkins
ARG group=jenkins
ARG uid=2000
ARG gid=33

ENV JENKINS_HOME /home/jenkins
ENV PATH "$PATH:/opt/android_tools/android-ndk-r16b:/opt/android_tools/android-sdk-linux"

RUN useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN apt-get -y update && \
    apt-get -y install unzip tar curl openssh-server git zip ninja-build && \
    apt-get clean

RUN sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd
RUN echo "jenkins:jenkins" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
