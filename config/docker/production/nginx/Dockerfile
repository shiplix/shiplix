FROM nginx

ENV VIRTUAL_HOST */assets/*,*/videos/*,*/robots.txt,*/favicon.ico
ENV VIRTUAL_HOST_WEIGHT 1

COPY public /app/public

COPY config/docker/production/nginx/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx"]
