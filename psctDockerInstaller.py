#!/usr/bin/env python3

import os
import subprocess
import shutil
import sys

def install_and_import(package):
    try:
        import importlib
        importlib.import_module(package)
    except ImportError:
        import pip
        pip.main(['install', package])
    finally:
        globals()[package] = importlib.import_module(package)

install_and_import('cryptography')

from cryptography.hazmat.primitives import serialization as crypto_serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.backends import default_backend as crypto_default_backend

if sys.version_info[0] < 3:
    sys.exit("Error: This script requires Python 3. Please update your Python version.")

# Function to check if ssh-keygen is available
def is_tool(name):
    from shutil import which
    return which(name) is not None

def generate_ssh_key(filename):
    key = rsa.generate_private_key(
        backend=crypto_default_backend(),
        public_exponent=65537,
        key_size=2048
    )
    private_key = key.private_bytes(
        crypto_serialization.Encoding.PEM,
        crypto_serialization.PrivateFormat.PKCS8,
        crypto_serialization.NoEncryption()
    )
    public_key = key.public_key().public_bytes(
        crypto_serialization.Encoding.OpenSSH,
        crypto_serialization.PublicFormat.OpenSSH
    )

    with open(filename, 'wb') as f:
        f.write(private_key)
    
    with open(filename + '.pub', 'wb') as f:
        f.write(public_key)

# Set Docker image name
imagename = "psct_docker"

# Set the SSH key path
ssh_key_path = os.path.expanduser("~/.ssh/gitlab_docker")

## Prompt the user for their GitLab email
#gitlab_email = input("Please enter your GitLab email: ")
#

#
# Comment above and Uncomment below to skip entering gitLab email everytime
gitlab_email = "bryce.hoecker@cta-consortium.org"
#

# Check if the SSH key already exists
if not os.path.isfile(ssh_key_path):
    print("Generating a new SSH key...")
    if is_tool("ssh-keygen"):
        subprocess.run(["ssh-keygen", "-t", "ed25519", "-C", gitlab_email, "-f", ssh_key_path, "-N", ""])
    else:
        generate_ssh_key(ssh_key_path)
else:
    print("Existing SSH key found, skipping generation.")

# Print the public key
with open(f"{ssh_key_path}.pub", "r") as f:
    print("Please add the following public key to your GitLab account:\n", f.read())

# Prompt user for confirmation (comment out to skip waiting period for user to copy ssh key)
#input("Press enter to continue once you've added the SSH key to your GitLab account...")

# Load the SSH key
with open(ssh_key_path, "r") as f:
    ssh_private_key = f.read()

# Build the Docker image
print("Now building the Docker image {} ....".format(imagename))
subprocess.run(["docker", "build", "--build-arg", f"SSH_PRIVATE_KEY={ssh_private_key}", "-t", imagename, "."])

print("Docker image {} has finished attempting to build.".format(imagename))

# Run the Docker container interactively
print("Now running the {} Docker container interactively.".format(imagename))
subprocess.run(["xhost", "+local:docker"])
subprocess.run(["docker", "run", "-it", "-e", "DISPLAY", "-v", "/tmp/.X11-unix:/tmp/.X11-unix", imagename, "/bin/bash"])



## Run the Docker container interactively
#print("Now running the {} Docker container interactively.".format(imagename))
#subprocess.run(["docker", "run", "-it", imagename])
