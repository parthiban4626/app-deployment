# Using Nginx base image to serve static files
FROM nginx:alpine

# Removing default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy built React files
COPY build/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
