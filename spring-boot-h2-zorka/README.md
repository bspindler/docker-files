## Base spring-boot application w/docker support

### Project objective
The objective of this project is to showcase how the Netuitive JVM Agent (Zorka) can be used to monitor a simple Spring-Boot application
running the Apache Tomcat server and H2 Database.  We'll showcase how to setup the JVM agent to capture runtime statistics on your JVM, Http
and SQL stacks, along with how to automatically capture slow `http` or `sql` queries directly to a log for follow up / troubleshooting.

### Project setup
  - Latest spring-boot stack (currently v1.4.0-RELEASE) with:
    - Apache Tomcat
    - H2 Database
  - Gradle (it's embedded with project)
  - Docker plugin to gradle which adds 'buildDocker' task (added to build.gradle)
  - Dockerfile with alpine base (~120mb) + app.jar

### Quick start
  - ensure your docker environment is properly setup and run:
  - `./gradlew build buldDocker && docker run -p 8080:8080 -d --name spring-boot-docker spring-boot-docker`
  - go to `http://<ip docker host>:8080/console` or `http://<ip docker host>:8080/` to see 'Hello Docker World'

### Functionality
  - one rest controller that maps to `/` and responds with "Hello Docker World"
  - on `/console` you will find the H2 Web Database Console
    - for those interested, in `WebConfiguration` you'll find the `org.h2.server.web.WebServlet` getting registered.    

### Running the example
  - build docker image, and run it on port 8080
    - `./gradlew build buildDocker`
      - you need to have DOCKER_* env variables setup, see https://github.com/wsargent/docker-cheat-sheet
    - `docker run -p 8080:8080 -d --name spring-boot-docker spring-boot-docker`
  - in order to 'redeploy' an instance of this container, the following additional step must be taken
    - `docker rm -f --name spring-boot-docker`
    - if you are not seeing the latest code running, it may be necessary to explicitly delete the image and rebuild.  In that case, the following additional step can be taken:
      - `docker rmi -f spring-boot-docker`

## Integrating Netuitive JVM Agent (Zorka) with your application
Integrating the Netuitive JVM Agent requires adding the distribution and configuring the `zorka.properties` file
  - Download and install the agent:
    - `curl -s https://repos.uat.netuitive.com/java-agent/netuitive-zorka-1.0.16.zip --output netuitive-zorka-1.0.16.zip`
    - into an install directory: `unzip netuitive-zorka-1.0.16.zip`
    - add agent to java: `-javaagent:<agent-install-dir>/netuitive.jar=<agent-install-dir>`
  - For this example, update the `zorka.properties` file and set the following properties to
    - `scripts = jvm.bsh, apache/tomcat.bsh, jdbc/h2.bsh`
  - **To enable sql tracing**, update the `zorka.properties` file and set the following properties to
    - `sql.tracer = yes`
  - **To enable slow sql queries to get captured**, update the `zorka.properties` file and set the following properties to
    - `sql.slow = yes` - will produce a file `sql-slow.log`
    - `sql.slow.time = 100` - in millis, set appropriately, any query above this time will be considered slow
    - `sql.error = yes` - will produce a file `sql-error.log`

Example output from `sql-slow.log`:

2016-09-05 11:11:40 INFO sql.slow [`17ms`] jdbc:h2:~/test: `SELECT UPPER(VALUE) FROM INFORMATION_SCHEMA.SETTINGS WHERE NAME=?`

  - **To enable http tracing**, update the `zorka.properties` file and set the following properties to
    - `http.tracer = yes`
  - **To enable slow http requests to get captured**, update the `zorka.properties` file and set the following properties to
    - `http.slow = yes` - will produce a file `http-slow.log`
    - `http.params = no` - don't log params
    - `http.trace.time = 100` - in millis, set appropriately, any http req above this time will be considered slow
    - `http.error = yes` - will produce a file `http-error.log`

Example output from `http-slow.log`:

2016-09-05 11:11:36 INFO http.slow [`5.68ms`] `/console/login.jsp` -> 200

  - Finally, update `zorka.properties` with your netuitive api key and fire up the agent.
