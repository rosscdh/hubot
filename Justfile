
setup:
    docker run --rm -it -v $PWD:/src -w /src --entrypoint npm node:lts-alpine install --save hubot hubot-slack hubot-salt coffeescript@1.12.7
config:
    docker run --rm -it -v $PWD:/src -w /src --entrypoint npm node:lts-alpine install --save $(jq -r '.[]' ./external-scripts.json | paste -sd" " -)
build:
    docker build -t rosscdh/hubot:latest .
enter:
    docker run --rm -it --entrypoint sh rosscdh/hubot:latest
push:
    docker push rosscdh/hubot:latest