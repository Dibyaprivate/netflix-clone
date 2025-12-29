# ---------- Build Stage ----------
FROM node:20-alpine AS build
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Build the React app
RUN npm run build

# ---------- Runtime Stage ----------
FROM nginx:alpine

# Copy build output to nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Expose nginx port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
#-----------------------------multistagedockerfile--------------------------------
#🔹 Build Stage (React App Build)
#FROM node:20-alpine AS build
#Uses Node.js 20 with Alpine Linux (very lightweight)
#Names this stage build
#Used only to build the React app
#Node is needed here because React needs npm
#-----------------------------------------------------------------------------------
#WORKDIR /app
#Sets working directory inside container to /app
#All commands will run from this folder
#-----------------------COPY package*.json ./----------------------------------------
#COPY package*.json ./
#Copies package.json and package-lock.json
#Done before copying full source code
#Helps Docker cache dependencies (faster rebuilds)
#------------------------------------------------------------------------------------
#RUN npm install
#Installs all React dependencies
#Runs only if package.json changes
#------------------------------------------------------------------------------------
# COPY . .
#Copies entire project source code
#Includes src, public, config files
#------------------------------------------------------------------------------------
#RUN npm run build
#Builds the React app
#Generates a production build in /app/dist
#This output is static HTML, CSS, JS
#----------------------------------Runtime Stage (Nginx Server)------------------------
#FROM nginx:alpine
Starts a new image
Very small and fast
No Node.js here → more secure & lightweight
#-----------------------------------------------------------------------------------------
#COPY --from=build /app/dist /usr/share/nginx/html
#Copies only the built static files
#From build stage → Nginx HTML directory
#Node + source code are NOT copied ❌
#👉 This is the key benefit of multi-stage build
#-----------------------------------------------------------------------------
#EXPOSE 80
#Documents that container listens on port 80
#Does NOT open the port by itself
#Used by Docker/Kubernetes for networking
#------------------------------------------------------------------------------
#CMD ["nginx", "-g", "daemon off;"]
#Starts Nginx in foreground
#Required to keep container running
#Serves the React app
#------------------------------------------------------------------------------
#NOTE:I used a multi-stage Dockerfile where the React application is built in a Node.js environment and the final build artifacts are served using Nginx. This approach reduces image size, improves security, and follows production best practices.


