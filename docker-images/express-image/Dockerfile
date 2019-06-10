FROM node:10.16

WORKDIR /opt/app

LABEL authors = "Tiago Povoa, Christoph Rouff soit Rueff"

COPY src /opt/app

RUN npm install

CMD [ "node","/opt/app/index.js" ]
