FROM alpine:latest

RUN apk add --no-cache bash curl

WORKDIR /app

COPY . .

RUN chmod +x *.sh

CMD ["./deploy.sh"]