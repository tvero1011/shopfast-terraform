# Use a tiny version of Node.js to save space and money
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy the rest of your code
COPY . .

# Tell Docker which port the app uses
EXPOSE 3000

# The command to start the app
CMD [ "node", "server.js" ]