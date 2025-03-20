# Stage 1: Build the application with Maven and cache dependencies
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR  /projectbackups/My-Portfolio-Spring-Boot-Web-App-master

# Copy only pom.xml first (for better caching)
COPY pom.xml .

# Download dependencies before copying source files (ensures dependencies are cached)
RUN mvn dependency:go-offline

# Copy the rest of the application
COPY src ./src

# Build the project
RUN mvn clean package

# Stage 2: Create the final runtime image-----------------
FROM openjdk:21-slim
EXPOSE 5000

# Copy the built JAR file from the build stage----------
COPY --from=build /projectbackups/My-Portfolio-Spring-Boot-Web-App-master/target/*.jar app.jar

# Run the application--
ENTRYPOINT ["java", "-jar", "/app.jar"]
