FROM registry.access.redhat.com/ubi8

USER root

RUN HOME=/root && \
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \

INSTALL_PKGS="cargo npm openssl-devel libffi-devel libtool-ltdl python3-devel python3-pip python3-cryptography python3-mod_wsgi python3-wheel python3-setuptools jq httpd mod_ssl mod_session" && \
dnf module reset nodejs -y && \
dnf module install nodejs:14 -y && \
yum update -y && yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
yum -y clean all --enablerepo='*'

# Fixup handling for UNIX accounts.

RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    chmod g+w /etc/passwd

# Install configurable HTTP proxy.

RUN HOME=/root && \
    npm install -g configurable-http-proxy && \
    REMOVE_PKGS="cargo python3-devel openssl-devel libffi-devel libtool-ltdl gcc rust" && \
    pip3 install jmespath kubernetes==11.0.0 openshift==0.11.2 setuptools-rust && \
    pip3 install jupyterhub==1.1.0 jupyterhub-kubespawner==0.13.0 jupyterhub-tmpauthenticator==0.6 oauthenticator==0.10.0 wrapt==1.12.1 && \
    dnf remove -y $REMOVE_PKGS

# Common environment variables.

ENV HOME=/opt/app-root \
    NPM_CONFIG_PREFIX=/opt/app-root \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

# Install application software.

COPY . /opt/app-root/

RUN mkdir /opt/app-root/data && \ 
    chown -R 1001:0 /opt/app-root && \
    /opt/app-root/bin/fix-permissions /opt/app-root

WORKDIR /opt/app-root/src

USER 1001

# Finish environment setup.

ENV BASH_ENV=/opt/app-root/etc/profile \
    ENV=/opt/app-root/etc/profile \
    PROMPT_COMMAND=". /opt/app-root/etc/profile"

ENTRYPOINT [ "/opt/app-root/etc/entrypoint.sh" ]

CMD [ "/opt/app-root/etc/run.sh" ]
