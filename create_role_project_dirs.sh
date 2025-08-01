#!/bin/bash

# Usage: ./create_role_project.sh <project_name>

ROLE_BASE="./roles"
PROJECT_NAME=$1

# Check input
if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

PROJECT_PATH="$ROLE_BASE/$PROJECT_NAME"

# Create project role directories
mkdir -p "$PROJECT_PATH"/{defaults,files,handlers,meta,tasks,templates,vars}

# Create default main.yml in each necessary dir
touch "$PROJECT_PATH"/defaults/main.yml
touch "$PROJECT_PATH"/handlers/main.yml
touch "$PROJECT_PATH"/meta/main.yml
touch "$PROJECT_PATH"/tasks/main.yml
touch "$PROJECT_PATH"/vars/main.yml

echo "Role structure created at: $PROJECT_PATH"
