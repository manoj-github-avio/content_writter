# Build image
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /src
COPY pom.xml .
COPY src ./src
RUN mvn -q -DskipTests package

# Run image
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /src/target/*-SNAPSHOT.jar /app/app.jar
# Render sets $PORT; default to 8080 locally
ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["sh","-c","java -Dserver.port=${PORT} -jar /app/app.jar"]