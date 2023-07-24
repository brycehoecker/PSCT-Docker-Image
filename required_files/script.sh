#!/bin/bash

# Clone the repos listed in github_checkout.list
while read repo_url; do git clone "$repo_url"; done < github_checkout.list
rm github_checkout.list

# Function to check if the "targetcalib" directory exists and navigate into it
function navigate_to_targetcalib_directory() {
    if [ -d "targetcalib" ]; then
        echo "Found 'targetcalib' directory."
        cd "targetcalib"
        return 0
    else
        echo "Could not find 'targetcalib' directory."
        return 1
    fi
}

# Check if the script successfully navigates to the "targetcalib" directory
if navigate_to_targetcalib_directory; then
    # Run the 'git switch pSCT' command inside the "targetcalib" directory
    echo "Switching to the targetcalib pSCT branch"
    git switch pSCT
else
    echo "Exiting script."
fi




## CANT USE WHEN Without gitlab SSH key passed into the Dockerfile 
## Clone the repos listed in gitlab_checkout.list
#while read repo_url; do git clone "$repo_url"; done < gitlab_checkout.list
#rm gitlab_checkout.list
#
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
## Rest of the script...
## If i need anyelse put it here
