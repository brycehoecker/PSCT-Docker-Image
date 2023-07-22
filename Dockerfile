# Dockerfile
# PSCT Dockerfile written by Bryce Hoecker (CSUEB)
# Be Advised! Run at your own risk. I promise nothing. -Bryce Hoecker
# But feel free to email me if you run into any issues.
# School Email: bryce.hoecker@csueastbay.edu
# Personal Email:  brycehoecker@gmail.com

# Use the rockylinux:9.2 image as the base
FROM rockylinux:9.2

# Install necessary tools and enable EPEL and CRB Repos
RUN dnf -y update \
    && dnf install -y dnf-plugins-core \
    && dnf config-manager --set-enabled crb \
    && dnf install -y epel-release git openssh

# Set work directory & Copy the required_files directory into the image
WORKDIR /app
COPY required_files/ /app/

# Update the system and install programs listed in dnfinstall.list
RUN dnf -y update && \
    cat dnfinstall.list | xargs dnf -y install && \
    dnf clean all && \
    rm -f dnfinstall.list

# Change color profile
RUN echo 'PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> ~/.bashrc \
    && echo 'alias ls="ls --color=auto"' >> ~/.bashrc

# Set ssh key
ARG SSH_PRIVATE_KEY
RUN mkdir -p /root/.ssh/ \
    && echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa \
    && chmod 600 /root/.ssh/id_rsa \
    && ssh-keyscan gitlab.com >> /root/.ssh/known_hosts

# Install Miniforge (Conda + Mamba)
RUN curl -L -o miniforge.sh https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh \
    && /bin/bash miniforge.sh -b -p /opt/mambaforge \
    && rm miniforge.sh
ENV PATH="/opt/mambaforge/bin:$PATH"
# Set strict channel priority
RUN mamba config --set channel_priority strict
# Create the new mamba environment from mamba_environment.yml
RUN /bin/bash -c "source /opt/mambaforge/bin/activate && mamba env create -f mamba_environment.yml"

# Make script.sh executable, run it and then delete it
RUN chmod +x script.sh && \
    ./script.sh && \
    rm script.sh

# Make RUN commands use the new mamba_environment
SHELL ["conda", "run", "-n", "mymambaenv", "/bin/bash", "-c"]

# Delete the mamba_environment.yml file
RUN rm mamba_environment.yml


