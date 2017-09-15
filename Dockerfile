FROM centos7-jdk8-gradle

MAINTAINER Joshua T. Pyle <JPyle@woodmen.org>

ENV SERVER_PORT=8080 \
    MANAGEMENT_PORT=8081 \
    PATH="$PATH:"/usr/local/s2i"" \
    JAVA_DATA_DIR="/deployments/data" \
    GRADLE_HOME=/usr/local/gradle \
    JAVA_TOOL_OPTIONS=''


LABEL name="woodmenlife/springboot-gradle-s2i" \
      version="1.0" \
      release="10" \
      architecture="x86_64" \
      io.openshift.expose-services="8080:server,8081:managment" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.k8s.description="Platform for building and running Spring Boot applications" \
      io.k8s.display-name="Spring Boot Gradle 3" \
      io.openshift.tags="builder,java,java8,gradle,gradle3,springboot" \
      io.openshift.s2i.destination="/tmp/s2i"

# instead of using wget to download the garadle zip perhaps
# use ADD to add from a local file.  Then USER 0 would no
# longer be neccessary.
USER root

# create user
RUN adduser --system -u 10001 javauser -d /home/javauser -m
RUN mkdir -p /tmp/s2i && chown -R javauser: /tmp/s2i

COPY ./.s2i/bin/ /usr/local/s2i

RUN chmod +x /usr/local/s2i/*

USER 10001
EXPOSE $SERVER_PORT $MANAGEMENT_PORT

CMD ["/usr/local/s2i/run"]
