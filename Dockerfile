FROM python:3.6-alpine3.10
WORKDIR /usr/src/app
RUN apk add --no-cache postgresql-dev build-base musl-dev libffi libffi-dev bash dos2unix
RUN addgroup -S gengine
RUN adduser -S -D -h /usr/src/app gengine gengine
RUN mkdir /run/uwsgi
RUN chown -R gengine:gengine /run/uwsgi

# Install a compatible version of setuptools first
RUN pip3 install setuptools==45

COPY requirements.txt ./
COPY optional-requirements.txt ./
COPY docker-files/* ./
RUN cat optional-requirements.txt >> requirements.txt && pip3 install -r requirements.txt
COPY . .

# Fix line endings and permissions on shell scripts
RUN dos2unix init.sh wait-for-it.sh
RUN chmod +x init.sh wait-for-it.sh

RUN pip3 install -e . && touch /tmp/nginx.socket
RUN chown -R gengine:gengine /usr/src/app
CMD [ "/bin/sh", "/usr/src/app/init.sh" ]
