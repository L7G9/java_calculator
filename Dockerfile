FROM openjdk:17
COPY build/libs/calculator-0.0.1-SNAPSHOT.jar app.jar
COPY /tmp/calculator.mv.db /tmp/calculator.mv.db
ENTRYPOINT ["java", "-jar", "app.jar"]
