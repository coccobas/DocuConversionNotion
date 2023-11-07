FROM 10.8.0.102:443/beaglesystems/node

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y --quiet --no-install-recommends install \
        build-essential \
        curl \
        git \
        python3 \
        python3-pip \
        python3-dev \
        # texlive-full \
        # texlive-latex-extra \
        graphviz \
        libnss3 \
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

USER root
WORKDIR /root

RUN useradd -ms /bin/bash user
RUN chown -R user /home/user/
RUN chgrp -R user /home/user/
USER user
COPY --chown=user requirements.txt /home/user/docs/requirements.txt
WORKDIR /home/user/docs

RUN pip3 install --upgrade pip
RUN pip3 install --user -r requirements.txt

COPY --chown=user . /home/user/docs

RUN npm install puppeteer@21.5.0 && \
    npm install mermaid@10.6.0 && \
    npm install @mermaid-js/mermaid-cli@10.6.0

RUN make html
# RUN make latexpdf

COPY ./app.py /app/app.py

ENTRYPOINT ["/usr/bin/python3"]
CMD ["app.py"]
