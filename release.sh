#!/bin/bash

# Replace these variables with your repository details
REPO_OWNER="phhgsi"
REPO_NAME="derpfest_releases"
TAG_NAME="v1.3"
RELEASE_NAME="derp"
RELEASE_BODY="Description of the release."

# File name of the zip file in the same directory
ZIP_FILE_NAME="DerpFest-14-Official-Beta-oscar-20240107.zip"

# Create a release using GitHub CLI
gh release create $TAG_NAME "$ZIP_FILE_NAME" --title "$RELEASE_NAME" --notes "$RELEASE_BODY"

# Check if the release was created successfully
if [ $? -eq 0 ]; then
  echo "Release created successfully"
else
  echo "Failed to create release"
  exit 1
fi
