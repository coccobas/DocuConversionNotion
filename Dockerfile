FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_VERSION=19.2.0

RUN apt-get update \
    && apt-get -y --quiet --no-install-recommends install \
        build-essential \
        curl \
        git \
        python3 \
        python3-pip \
        python3-dev \
        texlive-full \
        texlive-latex-extra \
        graphviz \
        libx11-xcb-dev \
        libxcomposite-dev \
        libxcursor-dev \
        libxdamage-dev \
        libxtst-dev \
        libxss-dev \
        libxrandr-dev \
        libasound-dev \
        libatk1.0-dev \
        libatk-bridge2.0-dev \
        libpango1.0-dev \
        libgtk-3-dev \
        wget \
    && apt-get -y --quiet autoremove \
    && apt-get clean autoclean \
    && rm -rf /var/lib/apt/lists /tmp/* /var/tmp/* /root/.cache \
    && apt-get -y --quiet autoremove

COPY requirements.txt /home/user/docs/requirements.txt
WORKDIR /home/user/docs
RUN pip3 install -r requirements.txt

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version && npm install @mermaid-js/mermaid-cli

RUN useradd -ms /bin/bash user
RUN chown -R user /home/user/
RUN chgrp -R user /home/user/
USER user
COPY . /home/user/docs

RUN make html
RUN make latexpdf

COPY ./app.py /app/app.py

ENTRYPOINT ["/usr/bin/python3"]
CMD ["app.py"]
