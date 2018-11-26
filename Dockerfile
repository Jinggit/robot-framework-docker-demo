FROM ubuntu:16.04
# Juho Pekki, 17.7.2017
# old version was deprecated, because usage of the latest software versions
ENV LANG C.UTF-8
ENV FIREFOX_VERSION 63.0
ENV GECKODRIVER_VERSION 0.23.0
ENV CHROMEDRIVER_VERSION 2.44

RUN \
apt-get update && \
apt-get install -y \
python-pip \
ttf-wqy-microhei \
ttf-wqy-zenhei \
unzip \
git \
libpango1.0-0 \
libgconf2-4 \
libnss3-1d \
libxss1 \
fonts-liberation \
libappindicator1 \
libindicator7 \
xdg-utils \
curl \
ca-certificates \
firefox \
wget \
xvfb \
gtk2-engines-pixbuf \
xfonts-100dpi \
xfonts-75dpi \
xfonts-scalable \
xfonts-cyrillic \
xfonts-base \
imagemagick \
python-setuptools

#install firefox
RUN wget https://ftp.mozilla.org/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2
RUN apt-get -y purge firefox && \
rm -rf /opt/firefox && \
tar -C /opt -xjf firefox-$FIREFOX_VERSION.tar.bz2 && \
rm -f firefox-$FIREFOX_VERSION.tar.bz2 && \
mv /opt/firefox /opt/firefox-$FIREFOX_VERSION && \
ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox

#install chrome
ADD google-chrome-stable_current_amd64.deb /
RUN chmod +777 google-chrome-stable_current_amd64.deb 
RUN dpkg -i google-chrome-stable_current_amd64.deb
COPY google-chrome-launcher /opt/google-chrome-launcher
RUN cat /opt/google-chrome-launcher > /usr/bin/google-chrome && \
rm -f /opt/google-chrome-launcher

# Install chromedriver
RUN wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
unzip chromedriver_linux64.zip && rm -f chromedriver_linux64.zip && \
chmod +777 chromedriver && mv -f chromedriver /usr/bin/chromedriver && \
apt-get autoremove -y unzip

# Install geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz && \
tar xfvz geckodriver-*.tar.gz && rm -f geckodriver-*.tar.gz && \
chmod +777 geckodriver && mv -f geckodriver /usr/bin/geckodriver

#Install robotframework
RUN pip install -U robotframework robotframework-selenium2library requests urllib3 robotframework-requests docutils && \
apt-get autoremove -y && \
rm -rf /var/lib/apt/lists/*


COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["start.sh"]
