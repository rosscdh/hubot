# ------------------------------------------------------
#                       Dockerfile
# ------------------------------------------------------
# image:    hubot
# name:     minddocdev/hubot
# repo:     https://github.com/mind-doc/hubot
# Requires: node:alpine
# authors:  development@minddoc.com
# ------------------------------------------------------

FROM node:lts-alpine

LABEL maintainer="development@minddoc.com"

# Install hubot dependencies
RUN apk update\
 && apk upgrade\
 && apk add jq\
 && npm install -g yo generator-hubot@next\
 && rm -rf /var/cache/apk/*

# Create hubot user with privileges
RUN addgroup -g 501 hubot\
 && adduser -D -h /hubot -u 501 -G hubot hubot
ENV HOME /home/hubot
WORKDIR $HOME
COPY . .
RUN chown -R hubot:hubot .
USER hubot
RUN npm i
# Install hubot version HUBOT_VERSION
ENV HUBOT_NAME "robot"
ENV HUBOT_OWNER "MindDoc <development@minddoc.com>"
ENV HUBOT_DESCRIPTION "A robot may not harm humanity, or, by inaction, allow humanity to come to harm"
RUN yo hubot\
 --adapter=slack\
 --owner="$HUBOT_OWNER"\
 --name="$HUBOT_NAME"\
 --description="$HUBOT_DESCRIPTION"\
 --defaults

EXPOSE 80

ENTRYPOINT ["bin/hubot"]

CMD ["--name", "$HUBOT_NAME", "--adapter", "slack"]
