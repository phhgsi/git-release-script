#!/bin/bash

# Replace these variables with your repository details
REPO_OWNER="phhgsi"
REPO_NAME="derpfest_releases"
TAG_NAME="v1.3"
RELEASE_NAME="derp"
RELEASE_BODY="Description of the release."

# File name of the zip file in the same directory
ZIP_FILE_NAME="DerpFest-14-Official-Beta-oscar-20240107.zip"

# GitHub API URL
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases"

# Create a release
response=$(curl -s -X POST -H "Authorization: token $(cat ~/.ssh/id_rsa)" -H "Accept: application/vnd.github.v3+json" \
  $API_URL \
  -d '{"tag_name": "'$TAG_NAME'", "name": "'$RELEASE_NAME'", "body": "'$RELEASE_BODY'", "draft": false, "prerelease": false}')

# Extract the release ID from the response
release_id=$(echo $response | jq -r '.id')

if [ "$release_id" != "null" ]; then
  echo "Release created successfully with ID $release_id"
else
  echo "Failed to create release"
fi

# Upload the zip file as a release asset
upload_url=$(curl -s -H "Authorization: token $(cat ~/.ssh/id_rsa)" -H "Accept: application/vnd.github.v3+json" \
  $API_URL \
  | jq -r '.upload_url' \
  | cut -d "{" -f 1)

asset_url=$(curl -s -H "Authorization: token $(cat ~/.ssh/id_rsa)" -H "Accept: application/vnd.github.v3+json" \
  -H "Content-Type: application/zip" \
  --data @"$ZIP_FILE_NAME" \
  $upload_url"?name=$ZIP_FILE_NAME" \
  | jq -r '.browser_download_url')

if [ "$asset_url" != "null" ]; then
  echo "Zip file uploaded successfully: $asset_url"
else
  echo "Failed to upload zip file"
fi
