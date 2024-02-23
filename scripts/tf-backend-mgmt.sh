#!/bin/bash

CF_API_TOKEN=""
CF_ACCOUNT_ID=""
CF_RESPONSE=""
CF_BUCKET_NAME=""
CF_BUCKETS=""

help() {
  echo ""
  echo "Script to manage Cloudflare R2 buckets for Terraform Backend."
  echo "Usage: $0 -t YOUR_API_TOKEN -a YOUR_ACCOUNT_ID"
  echo ""
  echo "  -t, --token <YOUR_API_TOKEN>     Your Cloudflare API Token"
  echo "  -a, --account <YOUR_ACCOUNT_ID>  Your Cloudflare Account ID"
  echo "  -C <YOUR_BUCKET_NAME>            Create Bucket with <YOUR_BUCKET_NAME> name"
  echo "  -c, --create                     Create Bucket with name defined in environment variables"
  echo "  -D <YOUR_BUCKET_NAME>            Delete Bucket with <YOUR_BUCKET_NAME> name"
  echo "  -d, --delete                     Delete Bucket with name defined in environment variables"
  echo "  -e, --env                        Use environment variables"
  echo "  -h, --help                       Display this help"
  echo ""
  exit 1
}

list_buckets() {
  CF_RESPONSE=$(curl --request GET "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/r2/buckets" \
    --header "Authorization: Bearer $CF_API_TOKEN" \
    --header "Content-Type: application/json")
  CF_BUCKETS=$(echo $CF_RESPONSE | jq -r '.result.buckets[].name')
}

if [ $# -eq 0 ]; then
  help
  exit 1
fi

LOAD_FROM_ENV=false
LIST_ALL_BUCKETS=false
CREATE_BUCKET=false
DELETE_BUCKET=false

while [ "$1" != "" ]; do
  case $1 in
    -t | --token )
      shift
      CF_API_TOKEN=$1
      ;;
    -a | --account )
      shift
      CF_ACCOUNT_ID=$1
      ;;
    -h | --help )
      help
      ;;
    -e | --env )
      LOAD_FROM_ENV=true
      ;;
    -l | --list )
      LIST_ALL_BUCKETS=true
      ;;
    -C )
      shift
      CREATE_BUCKET=true
      CF_BUCKET_NAME=$1
      ;;
    -c | --create )
      CREATE_BUCKET=true
      LOAD_FROM_ENV=true
      ;;
    -D )
      shift
      DELETE_BUCKET=true
      CF_BUCKET_NAME=$1
      ;;
    -d | --delete )
      DELETE_BUCKET=true
      LOAD_FROM_ENV=true
      ;;
    * )
      echo "Invalid option: $1"
      help
      ;;
  esac
  shift
done

if [ LOAD_FROM_ENV ]; then
  if [ -z "$CF_API_TOKEN" ] || [ -z "$CF_ACCOUNT_ID" ] || [ -z "$CF_BUCKET_NAME" ]; then
    if [ -f ".env" ]; then
      echo "Loading environment variavles from .env file..."
      source .env
    fi
    if [ -z "$CF_API_TOKEN" ] && [ ! -z "$ENV_CF_API_TOKEN" ]; then
      CF_API_TOKEN=$ENV_CF_API_TOKEN
    fi
    if [ -z "$CF_ACCOUNT_ID" ] && [ ! -z "$ENV_CF_ACCOUNT_ID" ]; then
      CF_ACCOUNT_ID=$ENV_CF_ACCOUNT_ID
    fi
    if [ -z "$CF_BUCKET_NAME" ] && [ ! -z "$ENV_CF_BUCKET_NAME" ]; then
      CF_BUCKET_NAME=$ENV_CF_BUCKET_NAME
    fi
  fi
fi

if [ -z "$CF_API_TOKEN" ] || [ -z "$CF_ACCOUNT_ID" ]; then
  echo "Error: Cloudflare API Token and Account ID are required."
  echo "---"
  help
fi

list_buckets

if [ $CREATE_BUCKET == true ]; then
  if [[ ! $CF_BUCKETS == *"$CF_BUCKET_NAME"* ]] || [ -z "$CF_BUCKET_NAME" ]; then
    CF_RESPONSE=$(curl --request POST "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/r2/buckets" \
      --header "Authorization: Bearer $CF_API_TOKEN" \
      --header "Content-Type: application/json" \
      --data '{"name": "'$CF_BUCKET_NAME'"}')
  fi
fi

if [ $DELETE_BUCKET == true ]; then
  if [[ $CF_BUCKETS == *"$CF_BUCKET_NAME"* ]]; then
    CF_RESPONSE=$(curl --request DELETE "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/r2/buckets/$CF_BUCKET_NAME" \
      --header "Authorization: Bearer $CF_API_TOKEN" \
      --header "Content-Type: application/json")
  fi
fi

if [ $LIST_ALL_BUCKETS == true ]; then
  list_buckets
  echo $CF_BUCKETS
fi
