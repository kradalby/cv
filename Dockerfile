FROM node:latest as build

RUN apt-get update
RUN apt-get install wkhtmltopdf perl -y --force-yes
RUN npm install fluentcv -g --silent
RUN npm install jsonresume-theme-slick --silent

COPY resume.json resume.json

RUN fluentcv BUILD resume.json TO out/cv.all -t node_modules/jsonresume-theme-slick
RUN perl -pi -E 's/link href="http/link href="https/g' out/cv.html
RUN perl -pi -E "s/link href='http/link href='https/g" out/cv.html

FROM nginx:alpine 
COPY --from=build out /usr/share/nginx/html
RUN cp /usr/share/nginx/html/cv.html /usr/share/nginx/html/index.html
