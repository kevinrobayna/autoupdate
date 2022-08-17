FROM node:lts-alpine as builder

RUN mkdir -p /opt/shipit/dist

WORKDIR /opt/shipit

COPY . /opt/shipit/

RUN npm install --frozen-lockfile && npm run build

FROM node:lts-alpine as runner

LABEL version="0.0.1" \
      repository="https://github.com/kevinrobayna/shipit" \
      homepage="https://github.com/kevinrobayna/shipit" \
      com.github.actions.name="Auto-update pull requests with changes from their base branch" \
      com.github.actions.description="A GitHub Action that auto-updates PRs with changes from their base branch" \
      com.github.actions.icon="git-pull-request" \
      com.github.actions.color="blue"

RUN apk add --update --no-cache ca-certificates \
  && mkdir -p /opt/shipit

WORKDIR /opt/shipit

COPY --from=builder /opt/shipit/dist/index.js /opt/shipit/index.js

ENTRYPOINT [ "node", "/opt/shipit/index.js" ]
