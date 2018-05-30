FROM node:8-alpine

ENV APP_DIR /opt/growi

RUN apk add --no-cache --virtual .dl-deps git curl \
    && mkdir -p ${APP_DIR} \
    && git clone -b feat/gcs_support https://github.com/sawadakaku/growi.git ${APP_DIR}

WORKDIR ${APP_DIR}

RUN yarn \
    # install official plugins
    && yarn add growi-plugin-lsx growi-plugin-pukiwiki-like-linker \
    && npm run build:prod \
    # shrink dependencies for production
    && yarn install --production \
    && yarn cache clean

# install dockerize
ENV DOCKERIZE_VERSION v0.5.0
RUN apk add --no-cache --update tar
RUN curl -SL https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
        | tar -xz -C /usr/local/bin \
    && apk del .dl-deps


# install plugins if necessary
# ;;
# ;; NOTE: In GROWI v3 and later,
# ;;       2 of official plugins (growi-plugin-lsx and growi-plugin-pukiwiki-like-linker)
# ;;       are now included in the 'weseek/growi' image.
# ;;       Therefore you will not need following lines except when you install third-party plugins.
# ;;
#RUN echo "install plugins" \
#  && yarn add \
#      growi-plugin-XXX \
#      growi-plugin-YYY \
#  && echo "done."
# you must rebuild if install plugin at least one
# RUN npm run build:prod
