FROM nginx:alpine
 
RUN apk update && apk add bash

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8000

CMD ["/bin/sh" , "-c" , "exec nginx -g 'daemon off;'"]