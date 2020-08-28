# DOCKER-VERSION 0.3.4
FROM        perl:latest
MAINTAINER  Maximiliano Schvindt schvindt@gmail.com

RUN curl -L http://cpanmin.us | perl - App::cpanminus

RUN git clone https://github.com/shmakins/perl-api-rest.git  rest
RUN cd rest && cpanm --installDeps .

EXPOSE 5000

WORKDIR rest

#perl script/perlrest_app_server.pl -p 5000
CMD ["starman", "-w", "2", "-p", "5000", "script/perlrest_app_psgi.pl" ]
