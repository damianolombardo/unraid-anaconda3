FROM continuumio/anaconda3

WORKDIR /
COPY docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

EXPOSE 8888
EXPOSE 7777

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/docker-entrypoint.sh" ]
