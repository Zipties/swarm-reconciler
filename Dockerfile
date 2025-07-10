FROM alpine
RUN apk add --no-cache bash docker-cli
COPY monitor.sh /monitor.sh
CMD ["bash","/monitor.sh"]
