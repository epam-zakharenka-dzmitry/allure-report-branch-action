FROM timbru31/java-node:17-alpine-jre-20

USER root

RUN echo "=======SETTING_JAVA_11_START========"

# Install openjdk11
RUN apk add --no-cache openjdk11

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"

# Go back to the node user
USER node

RUN echo "=======SETTING_JAVA_11_END========"

ARG RELEASE=2.27.0
ARG ALLURE_REPO=https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline

RUN echo "===============" && \
    echo JAVA_HOME: $JAVA_HOME && \
    echo Allure: $RELEASE && \
    echo NodeJS: $(node --version) && \
    java -version && \
    echo "===============" && \
    apk update && apk add git && \
    wget --no-verbose -O /tmp/allure-$RELEASE.tgz $ALLURE_REPO/$RELEASE/allure-commandline-$RELEASE.tgz && \
    tar -xf /tmp/allure-$RELEASE.tgz && \
    rm -rf /tmp/* && \
    chmod -R +x /allure-$RELEASE/bin && \
    mv /allure-$RELEASE /allure-commandline

COPY dist /js-action

ENTRYPOINT ["node", "/js-action/index.js"]
