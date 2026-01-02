FROM maven:3.9-amazoncorretto-17-alpine AS build
WORKDIR /app
COPY . .

RUN mvn clean package -DskipTests

FROM amazoncorretto:17-alpine

WORKDIR /app
COPY --from=build /app/target/*.jar mock-server.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "mock-server.jar"]