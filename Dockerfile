# Base on offical Node.js Alpine image
FROM node:18-alpine

# Set working directory
WORKDIR /usr/src/app/storefront
# RUN useradd -G www-data,root -u $uid -d /home/$user $user

# Install PM2 globally
RUN npm install --global pm2

# Copy package.json and package-lock.json before other files
# Utilise Docker cache to save re-installing dependencies if unchanged
COPY --chown=node:node ./package*.json ./

# Install dependencies
RUN npm install

# Copy all files
COPY --chown=node:node ./ ./

# Build app
RUN npm run build

# Expose the listening port
EXPOSE 3001

# Run npm start script with PM2 when container starts
# CMD [ "npm", "run", "start" ]
CMD [ "pm2-runtime", "npm", "--", "start" ]