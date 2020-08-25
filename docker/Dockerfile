# DOCKER-VERSION 0.3.4
FROM        perl:latest
MAINTAINER  Maximiliano Schvindt schvindt@gmail.com

RUN curl -L http://cpanmin.us | perl - App::cpanminus

RUN git clone https://github.com/Cuchu/perl-api-rest.git rest
RUN cd rest && cpanm --installDeps .

# Fix DBD::SQLite module - You don't need this step
RUN cpanm DBD::SQLite

EXPOSE 5000

WORKDIR rest

#perl script/perlrest_app_server.pl -p 5000
CMD ["perl","script/perlrest_app_server.pl","-p", "5000"]
