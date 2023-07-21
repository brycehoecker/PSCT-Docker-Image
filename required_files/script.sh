#!/bin/bash

# Clone the repos listed in github_checkout.list
while read repo_url; do git clone "$repo_url"; done < github_checkout.list
rm github_checkout.list





# USE WHEN/IF the github_checkout.list is formatted like 
# username/repositoryname
#
## Clone the repos listed in github_checkout.list
#while read repo; do git clone "https://github.com/$repo.git"; done < github_checkout.list
#rm github_checkout.list
#
# Rest of your script...
## Ask for the GitHub token
#echo "Please enter your GitHub token:"
#read GITHUB_TOKEN
#
## Use the GitHub token to clone the repos listed in github_checkout.list
#while read repo; do git clone "https://${GITHUB_TOKEN}@github.com/$repo.git"; done < github_checkout.list
#rm github_checkout.list
#
## Rest of your script...

