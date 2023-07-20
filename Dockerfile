# Dockerfile
# PSCT Dockerfile written by Bryce Hoecker (CSUEB)
# Be Advised! Run at your own risk. I promise nothing. -Bryce Hoecker
# But feel free to email me if you run into any issues.
# School Email: bryce.hoecker@csueastbay.edu
# Personal Email:  brycehoecker@gmail.com

# Use the rockylinux:9.2 image as the base
FROM rockylinux:9.2

# Install necessary packages
RUN dnf -y update \
    && dnf install -y dnf-plugins-core \
    && dnf config-manager --set-enabled crb \
    && dnf install -y epel-release

# Copy the dnfinstall.list file into the Docker image
COPY dnfinstall.list /dnfinstall.list

# Install packages from the dnfinstall.list file
RUN dnf install -y $(cat /dnfinstall.list | tr '\n' ' ')

# Install mamba from the GitHub repo
RUN pip3 install git+https://github.com/mamba-org/mamba.git

# Set the working directory
WORKDIR /app

# Copy the environment.yml file into the Docker image
COPY environment.yml ./environment.yml

# Create the new mamba environment
RUN mamba env create -f environment.yml

# Make RUN commands use the new environment
SHELL ["conda", "run", "-n", "myenv", "/bin/bash", "-c"]
