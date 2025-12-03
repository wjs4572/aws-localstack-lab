# Simple nginx container to serve our static app
FROM nginx:alpine

# Copy app files to nginx html directory
COPY app/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Nginx runs automatically as the default CMD
