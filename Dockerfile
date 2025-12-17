 FROM eclipse-temurin:17-jdk

 WORKDIR /app  
 # here we create folder in container

 COPY . /app  
 #copy data from host to conatiner folder

 RUN javac app/src/Main.java  
 #here we compile java code first

 # Run the Java application when the container starts
CMD ["java", "Main"]
