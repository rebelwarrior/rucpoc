##Procedimiento para tomcat7 deploy en windows y Rails 4

1. Download JDK7 + tomcat7 + JRuby 1.7.5 + Mariadb5.5(or SQL db)
2. set `JRUBY_OPTS --2.0`
3. download and install JSE security files for Java7
4. __NO SPACES__ on path for tomcat!!! (no # either) (windows limitation)
5. at the WEB-INF dir do `jruby -S rake db:migrate RAILS_ENV=production`
6. Set Tomcat server Heap memory up on the Java tab (Rails 4 requirement)
   - `-XX:MaxPermSize=256M`
   - `-XX:PermSize=256M`
   
   
   
   
###En la maquina de deploy  

1. Utilize Warble 1.4.0.beta1
2. Cree un web.xml para que se copie no lo deje autogenerar.
3. Flip heroku settins en:
  - Gemfile
  - file
  - file