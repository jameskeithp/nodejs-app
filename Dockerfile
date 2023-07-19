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

# Make the container's port 8181 available to the outside world
EXPOSE 8181

# Define the command to run the app
CMD ["node", "app.js"]

