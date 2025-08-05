#!/bin/bash

# Prompt user for project name
read -p "Enter project name: " PROJECT_NAME

# Create Django project
django-admin startproject $PROJECT_NAME

# Immediately change into the project's directory
cd $PROJECT_NAME

# Prompt user for number of apps
while true; do
    read -p "Enter number of apps: " NUM_APPS
    if [[ $NUM_APPS =~ ^[0-9]+$ ]] && [ $NUM_APPS -gt 0 ]; then
        break
    else
        echo "Invalid input. Please enter a positive integer."
    fi
done

# Create apps
for ((i=1; i<=$NUM_APPS; i++)); do
    read -p "Enter app name $i: " APP_NAME

    # Create app
    python3 manage.py startapp $APP_NAME

    # Create urls.py in app directory
    touch $APP_NAME/urls.py

    # Edit urls.py
    echo "from django.urls import path
app_name = '$APP_NAME'
urlpatterns = [
    # Add your routes here
]" > $APP_NAME/urls.py

    # Add app to INSTALLED_APPS
    sed -i "/INSTALLED_APPS/a \    '$APP_NAME'," $PROJECT_NAME/settings.py
done