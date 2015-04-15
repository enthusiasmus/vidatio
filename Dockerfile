FROM ubuntu
MAINTAINER Christian Lehner <lehner.chri@gmail.com>

# prevents a weird error message
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y curl git

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh | bash

# set node path in container
ENV NODE_PATH=/root/.nvm/versions/node/v0.12.2/bin
ENV PATH=$PATH:$NODE_PATH

RUN cat ~/.nvm/nvm.sh >> ~/.nvm/installnode.sh
RUN echo "nvm install v0.12.2" >> ~/.nvm/installnode.sh

# bower shouln't be installed manual, it should be installed via package.json
RUN echo "npm install -g bower" >> ~/.nvm/installnode.sh
RUN sh ~/.nvm/installnode.sh

# set bash start directory to /var/www/vidatio
WORKDIR /var/www/vidatio

# create folder var/www/vidatio and copy the app
RUN mkdir -p /var/www/vidatio
COPY . /var/www/vidatio/

RUN npm install
RUN bower install --allow-root

# expose port 5000 to host OS
EXPOSE 5000

CMD ["node", "server.js"]
