FROM openjdk:8-alpine

# Create the application directory
RUN mkdir -p /opt/app

# Set environment variable
ENV PROJECT_HOME /opt/app

# Copy the JAR file into the container
COPY target/spring-boot-mongo-1.0.jar $PROJECT_HOME/spring-boot-mongo.jar

# Set the working directory
WORKDIR $PROJECT_HOME

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "spring-boot-mongo.jar"]
