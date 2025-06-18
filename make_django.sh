bash
#!/bin/bash

# Prompt user for project name
read -rp "Enter project name: " PROJECT_NAME

# Create Django project
django-admin startproject $PROJECT_NAME

# Prompt user for number of apps
read -rp "Enter number of apps: " NUM_APPS

# Create apps
for ((i=1; i<=$NUM_APPS; i++)); do
    read -rp "Enter app name $i: " APP_NAME

    # Create app
    python $PROJECT_NAME/manage.py startapp $APP_NAME

    # Create urls.py in app directory
    touch $PROJECT_NAME/$APP_NAME/urls.py

    # Edit urls.py
    echo "from django.urls import path
app_name = '$APP_NAME'
urlpatterns = [
    # Add your routes here
]" > $PROJECT_NAME/$APP_NAME/urls.py

    # Add app to INSTALLED_APPS
    sed -i "/INSTALLED_APPS/a \    '$APP_NAME'," $PROJECT_NAME/$PROJECT_NAME/settings.py
done
