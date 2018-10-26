FROM consol/centos-xfce-vnc
ENV REFRESHED_AT 2018-10-23

# go to root
USER 0

# install firefox
RUN yum update -y
RUN yum install -y firefox \
	&& yum clean all
	
# remove chromium-browser
RUN yum remove -y chromium

# install vscode
COPY vscode.repo /etc/yum.repos.d/vscode.repo
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN yum check-update -y
RUN yum install -y code 

# install pip
RUN yum install -y python-pip

# install nodejs and npm
RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
RUN yum -y install nodejs

# install git
COPY wandisco-git.repo /etc/yum.repos.d/wandisco-git.repo
RUN rpm --import http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
RUN yum install -y git

# copy in firefox autoconfig files to fix IPC bug (need to do this as user who will run firefox)
COPY firefox.cfg /usr/lib64/firefox/
COPY autoconfig.js /usr/lib64/firefox/defaults/pref/

# install nano
RUN yum install -y nano

# switch to non-root user
USER 1000

# install userland virtualenv and add to user path
RUN pip install --user virtualenv
RUN \
	echo "export PATH=$PATH:/headless/.local/bin" >> /headless/.bashrc