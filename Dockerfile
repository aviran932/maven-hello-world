FROM maven:3.9.9-amazoncorretto-17-al2023 AS build

ARG VERSION

WORKDIR /app

COPY myapp/pom.xml ./
RUN mvn dependency:go-offline -B

COPY myapp/src ./src

RUN mvn clean package -DskipTests -DfinalName=myapp-${VERSION}-SNAPSHOT

FROM amazoncorretto:17-alpine

WORKDIR /app

RUN addgroup --gid 1001 -S myappgroup && \
    adduser --uid 1001 -S myappuser -G myappgroup

USER myappuser

COPY --from=build /app/target/*.jar /app/app.jar

CMD ["java", "-jar", "/app/app.jar"]
