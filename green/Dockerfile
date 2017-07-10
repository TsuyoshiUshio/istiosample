# Simple html server by Nginx
# usage:
# docker build -t blue .
# docker run --name some-blue -d -p 8080:80 blue

FROM nginx

RUN mkdir /usr/share/nginx/html/auth
RUN mkdir /usr/share/nginx/html/web
ADD index.html /usr/share/nginx/html
ADD index.html /usr/share/nginx/html/web
ADD login.html /usr/share/nginx/html/auth
ADD login.html /usr/share/nginx/html
ADD logout.html /usr/share/nginx/html/auth
ADD logout.html /usr/share/nginx/html

