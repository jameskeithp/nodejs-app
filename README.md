Node.js Application with CI/CD using Google Cloud Build and Deployment to GKE

This project guide will help you set up a Continuous Integration/Continuous Deployment (CI/CD) pipeline using Google Cloud Build for a simple Node.js application. We will also be deploying this application to Google Kubernetes Engine (GKE) and setting up Google Cloud Monitoring and Logging.
Prerequisites

You will need the following:

    A Google Cloud account with a project set up
    Google Cloud SDK installed on your local machine
    Docker installed
    Node.js installed
    Python installed

Please refer to the official documentation for installation and setup guides for Google Cloud SDK, Docker, Node.js, and Python.
Step 1: Create a Node.js application

    Create a new directory for your application and navigate into it:

bash

mkdir nodejs-app && cd nodejs-app

    Initialize a new Node.js project:

bash

npm init -y

    Install Express.js:

bash

npm install express --save

    Create a new app.js file with the following content:

javascript

const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});

You now have a simple Node.js application running on port 8080.
Step 2: Dockerize the Node.js application

    Create a Dockerfile in the project root with the following content:

Dockerfile

# Use an official Node.js runtime as the base image
FROM node:14

# Set the working directory in the container to /app
WORKDIR /app

# Copy package.json and package-lock.json into the container at /app
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Bundle the app source inside the Docker image 
COPY . .

# Make the container's port 8080 available to the outside world
EXPOSE 8080

# Define the command to run the app
CMD ["node", "app.js"]

    Build and test your Docker image:

bash

docker build -t nodejs-app .
docker run -p 8080:8080 -d nodejs-app

Visit http://localhost:8080 to verify that your application is running correctly inside a Docker container.
Step 3: Set up Google Cloud Build

    Enable the Cloud Build API for your Google Cloud project:

bash

gcloud services enable cloudbuild.googleapis.com

    Create a cloudbuild.yaml file in your project root with the following content:

yaml

steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', 'gcr.io/$PROJECT_ID/nodejs-app', '.' ]
images:
- 'gcr.io/$PROJECT_ID/nodejs-app'

    Submit a manual build to Cloud Build using the gcloud CLI:

bash

gcloud builds submit --config cloudbuild.yaml .

Step 4: Set up Google Kubernetes Engine (GKE)

    Enable the GKE API for your Google Cloud project:

bash

gcloud services enable container.googleapis.com

    Create a Kubernetes cluster:

bash

gcloud container clusters create my-cluster --num-nodes=3

    Get authentication credentials for the cluster:

bash

gcloud container clusters get-credentials my-cluster

    Deploy the application to GKE:

bash

kubectl apply -f deployment.yaml

You will need to create a deployment.yaml file that describes your application deployment, services, and any other Kubernetes objects. Please refer to Kubernetes documentation for this.
Step 5: Monitor and Log the Application

    Enable the Cloud Monitoring and Cloud Logging APIs for your Google Cloud project:

bash

gcloud services enable monitoring.googleapis.com
gcloud services enable logging.googleapis.com

    Visit the Google Cloud Console and navigate to the "Monitoring" and "Logging" sections to configure and view metrics and logs for your application.

Note: This guide provides a basic overview of the process. For a highly available and resilient system, additional considerations such as multi-zone clusters, autoscaling, load balancing, health checks, and backup/recovery strategies should be explored. You could also consider integrating additional tools and practices such as automated testing in your Cloud Build configuration, Helm for Kubernetes deployment management, and infrastructure as code practices with tools like Terraform.
