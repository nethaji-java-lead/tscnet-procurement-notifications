# Stage 1: Build stage with JDK 21
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and resolve dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build final jar
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime stage with JRE 21
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy built artifact from stage 1
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]