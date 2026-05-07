# Usamos una imagen de Java 21
FROM eclipse-temurin:21-jdk-jammy

# Directorio de trabajo
WORKDIR /app

# Copiamos el proyecto
COPY . .

# Damos permisos y compilamos
RUN chmod +x mvnw
RUN ./mvnw clean install -DskipTests

# Exponemos el puerto que usa tu app
EXPOSE 8081

# Comando para arrancar
CMD ["java", "-jar", "target/eventMapAl-Andalus-0.0.1-SNAPSHOT.jar"]