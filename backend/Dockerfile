# Usamos una imagen de Java 21
FROM eclipse-temurin:21-jdk-jammy

# Directorio de trabajo
WORKDIR /app

# Copiamos todo el contenido del repositorio
COPY . .

# Nos movemos a la carpeta donde está el pom.xml y el mvnw
WORKDIR /app/backend/eventMapAl-Andalus

# Damos permisos y compilamos desde esa carpeta
RUN chmod +x mvnw
RUN ./mvnw clean install -DskipTests

# Exponemos el puerto (tu app usa el 8081 según application.properties)
EXPOSE 8080

# Comando para arrancar apuntando al jar generado
CMD ["java", "-jar", "target/eventMapAl-Andalus-0.0.1-SNAPSHOT.jar"]