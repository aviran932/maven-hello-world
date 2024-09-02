FROM maven:3.9.9-amazoncorretto-17-al2023 AS build

WORKDIR /app

COPY myapp/pom.xml ./
RUN mvn dependency:go-offline -B

COPY myapp/src ./src

RUN mvn clean package

FROM amazoncorretto:17-alpine

WORKDIR /app

COPY --from=build /app/target/myapp-1.0.0-SNAPSHOT.jar /app/app.jar

CMD ["java", "-jar", "/app/app.jar"]
