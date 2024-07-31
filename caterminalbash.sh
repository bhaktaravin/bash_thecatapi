#!/bin/bash

if ! command -v feh &> /dev/null; then 
	echo "feh is not installed. Installing..." 
	sudo apt-get update -y
	sudo apt-get install -y feh
	sudo apt-get install -y jq
else 
	echo "feh is already installed."

fi

API_KEY="YOUR_API_KEY"
endpoint="https://api.thecatapi.com/v1"
HEADERs="x-api-key: $API_KEY"


# Function to fetch a random cat image
fetch_cat_image() {
    response=$(curl -s -H "$HEADERS" "$endpoint/images/search")
    image_url=$(echo $response | jq -r '.[0].url')
    image_id=$(echo $response | jq -r '.[0].id')
    echo "Cat Image URL: $image_url"
    echo "Cat Image ID: $image_id"
    feh "$image_url"  # Display image using feh
    echo $image_id
}

# Function to vote on a cat image
vote_cat_image() {
    image_id=$1
    vote=$2
    response=$(curl -s -H "$HEADERS" -d "{\"image_id\":\"$image_id\",\"value\":$vote}" "$endpoint/votes")
    echo "Vote response: $response"
}

# Main script
image_id=$(fetch_cat_image)

echo "Do you like this cat image? (yes/no)"
read vote_response

if [[ $vote_response == "yes" ]]; then
    vote=1
elif [[ $vote_response == "no" ]]; then
    vote=0
else
    echo "Invalid response. Exiting."
    exit 1
fi

vote_cat_image $image_id $vote