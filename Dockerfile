FROM ubuntu:18.04

LABEL Name="ubuntu-robotframework-firefox-chrome"  
LABEL Url="https://remoinux.ddns.net/robotframework/ubuntu-robotframework-firefox-chrome"
LABEL image_tag="G00R00C00"
LABEL description="Image Docker2 Robotframework"
LABEL maintainer=richard.yves@gmail.com

USER root

ENV SCREEN_WIDTH 1280
ENV SCREEN_HEIGHT 720
ENV SCREEN_DEPTH 16

ENV FIREFOX_VERSION 73.0.1
ENV GECKO_VERSION v0.26.0
#ENV CHROME_DRIVER_VERSION 80.0.3987.106
ENV CHROME_DRIVER_VERSION 85.0.4183.87

COPY requirements.txt /tmp/requirements.txt
COPY entry_point.sh /opt/bin/entry_point.sh

RUN mkdir /test
COPY ./test/ /test

RUN apt update && apt-get update \
  && apt-get install --no-install-recommends -y python3 python3-pip python3-dev\
  && apt-get install --no-install-recommends -y xvfb curl unzip dpkg ffmpeg fonts-liberation libappindicator3-1 libxtst6 wget gcc libffi-dev libgbm1 \
  && apt-get install --no-install-recommends -y ca-certificates dbus libgtk-3-0 libdbus-glib-1-2 libnspr4  libnss3 xdg-utils musl-dev make openssl \
  && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade 'pip' setuptools \
  && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir -r /tmp/requirements.txt && rm -rf /tmp/requirements.txt

# Install of Firefox:
RUN export DEBIAN_FRONTEND=noninteractive \   
	&& DL="https://download.mozilla.org/?product=firefox-$FIREFOX_VERSION-ssl&os=linux64" \
	&& curl -sL $DL | tar -xj -C /opt \
	&& ln -s /opt/firefox/firefox /usr/local/bin/
  
# Install of Geckodriver:
RUN BASE_URL=https://github.com/mozilla/geckodriver/releases/download \
	&& curl -sL "$BASE_URL/$GECKO_VERSION/geckodriver-$GECKO_VERSION-linux64.tar.gz" | tar -xz -C /usr/local/bin \
	&& rm -rf /var/lib/apt/lists/*

# Install Chrome for Selenium
RUN curl "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o /chrome.deb \
	&& dpkg -i /chrome.deb || apt-get install --no-install-recommends -yf \
	&& sed -i "s/self._arguments\ =\ \[\]/self._arguments\ =\ \['--no-sandbox',\ '--disable-gpu'\]/" $( python3 -c "import site; print(site.getsitepackages()[0])")/selenium/webdriver/chrome/options.py \
	&& chmod 755 /opt/bin/entry_point.sh \
	&& rm /chrome.deb \
	&& rm -rf /var/lib/apt/lists/*

# Install chromedriver (version 2.31) for Selenium
RUN curl "https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip" -o /chromedriver.zip \
    && unzip /chromedriver.zip -d /usr/local/bin/ \
	&& chmod +x /usr/local/bin/chromedriver \
	&& rm -rf /var/lib/apt/lists/*
