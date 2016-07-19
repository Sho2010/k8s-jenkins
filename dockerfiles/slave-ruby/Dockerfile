FROM jenkinsci/jnlp-slave
MAINTAINER Sho2010 <sho20100@gmail.com>

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV PATH /opt/google-cloud-sdk/bin:$PATH

USER root

RUN apt-get update  -y && \
	  apt-get install --no-install-recommends --no-install-suggests -y \
    build-essential \
    curl \
    jq \
    bzip2 \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libxml2-dev \
    libxslt-dev && \
    rm -rf /var/lib/apt/lists/*

# install gcloud and kubectl
RUN curl https://sdk.cloud.google.com | bash && mv google-cloud-sdk /opt
RUN gcloud components install kubectl

# Install ruby-build & ruby
ARG RUBY_VERSION="2.3.0"
RUN git clone https://github.com/sstephenson/ruby-build.git /ruby-build && \
    /ruby-build/install.sh && \
    rm -fr /ruby-build && \
    ruby-build ${RUBY_VERSION} /usr/local && \
    echo 'gem: --no-rdoc --no-ri' >> /.gemrc && \
    gem install bundler

# install things globally, for great justice
# and don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	  BUNDLE_BIN="$GEM_HOME/bin" \
	  BUNDLE_SILENCE_ROOT_WARNING=1 \
	  BUNDLE_APP_CONFIG="$GEM_HOME"

ENV PATH $BUNDLE_BIN:$PATH
RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN" && \
    chmod 777 "$GEM_HOME" "$BUNDLE_BIN"

