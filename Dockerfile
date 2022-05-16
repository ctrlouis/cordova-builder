FROM ubuntu:22.04

ENV ANDROID_BUILD_TOOLS_VERSION=30.0.3
ENV ANDROID_PLATFORMS_VERSION=28

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    openjdk-8-jdk \
    libc6-dev-i386 \
    lib32z1

# install node
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

# install cordova & electron
RUN npm install -g cordova electron

# Setup android
## Install gradle
RUN wget https://services.gradle.org/distributions/gradle-7.4.2-bin.zip -P /tmp
RUN mkdir /opt/gradle
RUN unzip -d /opt/gradle /tmp/gradle-7.4.2-bin.zip

ENV PATH=$PATH:/opt/gradle/gradle-7.4.2/bin

## Install android sdk
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip -P /tmp
RUN mkdir -p /Development/android-sdk
RUN unzip -d /Development/android-sdk /tmp/commandlinetools-linux-8092744_latest.zip

ENV ANDROID_SDK_ROOT=/Development/android-sdk
ENV PATH=$PATH:/Development/android-sdk/cmdline-tools/bin
ENV PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools/
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/bin/
ENV PATH=$PATH:$ANDROID_SDK_ROOT/emulator/

RUN while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"
RUN while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "platforms;android-${ANDROID_PLATFORMS_VERSION}"

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

# Set /app folder as workdir
RUN mkdir /app
WORKDIR /app