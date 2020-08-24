# perl-api-rest
API REST in Perl using Catalyst (Without current experience)

#### Step 1 - Install perl and catalyst:
    - Install PERL (http://strawberryperl.com/)
    - Install Catalyst Framework: cpanm -f Catalyst::Devel
      In Windows, versions up to 5.20 fail during test-TCP, so, use force (-f)
    - Install: Catalyst::Controller::REST
    - Install: Catalyst::Model::DBI
    
#### Step 2 - Create project:
- [Video on Youtube][1]    

#### Step 3 - Run project:
``
perl script/perlrest_app_server.pl -p 5000
``

#### Step 4 - Test our new controller:
- [Postman template][2]

After run the rest, you can execute the postman request.

![Postman tests](postman/postman_00.png)
        



[1]: https://www.youtube.com/watch?v=eYlCxA1xCLE&list=PLuHGXfTWz_BMzvffPXShwvZxBuv9jAR49
[2]: https://documenter.getpostman.com/view/8137382/TVCY5rkb    