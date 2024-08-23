# Use an official Java runtime as a parent image
FROM openjdk:11-jre-slim

# Set environment variables
ENV JMETER_VERSION=5.6.3
ENV JMETER_HOME=/opt/apache-jmeter

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install JMeter
RUN wget -q https://downloads.apache.org/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -O /tmp/jmeter.tgz && \
    mkdir -p ${JMETER_HOME} && \
    tar -xzf /tmp/jmeter.tgz -C ${JMETER_HOME} --strip-components=1 && \
    rm /tmp/jmeter.tgz

# Set JMeter bin directory in PATH
ENV PATH="${JMETER_HOME}/bin:${PATH}"

# Set default command
CMD ["jmeter", "-v"]

