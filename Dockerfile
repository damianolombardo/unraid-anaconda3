FROM continuumio/anaconda3

WORKDIR /
COPY docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/docker-entrypoint.sh" ]
