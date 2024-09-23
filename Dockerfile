FROM openjdk:8-alpine

# Update the package manager and install bash (if required)
RUN apk update && apk add bash

# Create directory for the application
RUN mkdir -p /opt/app
ENV PROJECT_HOME /opt/app

# Set the MongoDB connection URI (replace with your own URI)
ENV MONGODB_URI="mongodb+srv://admin:admin123@mongodb-demo.p1jch.mongodb.net/?retryWrites=true&w=majority&appName=mongodb-demo"

# Copy the Spring Boot jar file into the container
COPY target/spring-boot-mongo-1.0.jar $PROJECT_HOME/spring-boot-mongo.jar

# Set the working directory
WORKDIR $PROJECT_HOME

# Expose the port the app runs on
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "./spring-boot-mongo.jar"]
