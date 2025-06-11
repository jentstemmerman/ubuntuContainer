# Base image
FROM ubuntu:22.04

# Set build-time variables for UID and GID
ARG PUID=1000
ARG PGID=1000

# Install required packages
RUN apt-get update && apt-get install -y \
    git \
    ssh \
    openssh-server \
    build-essential \
    devscripts \
    debhelper \
    wget \
    gnupg2 && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user with specified UID and GID
RUN groupadd -f -g ${PGID} jents && \
    useradd -m -u ${PUID} -g ${PGID} -s /bin/bash jents && \
    echo 'jents:Lampekap15' | chpasswd

# Generate SSH host keys
RUN mkdir -p /var/run/sshd && \
    ssh-keygen -A

# Configure SSH to allow password login and root login (optional)
RUN sed -i 's/#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Set working directory
WORKDIR /home/jents

# Run SSH daemon
CMD ["/usr/sbin/sshd", "-D"]
