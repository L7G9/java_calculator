FROM openjdk:17
COPY build/libs/calculator-0.0.1-SNAPSHOT.jar app.jar
RUN mkdir -p /tmp
COPY calculator.mv.db /tmp
ENTRYPOINT ["java", "-jar", "app.jar"]
