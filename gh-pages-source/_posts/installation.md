#Instalación en Windows (solo Deploy)

1. [JavaSDK]()
2. [Java JCE]()
1. [Tomcat7]()
2. [JRuby](www.jruby.org) opcional necesario para las migraciones del db.
3. [Mariadb]()

Hmmm... Maybe I should create a SaltStack script for this...

#Instalación en Mac/Linux (para Development)
###Mac
1. [RVM](www.rvm.io) (opcional puedes usar homebrew tambien pero RVM es mejor.) 
   commando: `\curl -sSL https://get.rvm.io | bash -s stable`

2. [Homebrew](http://brew.sh/) comando: 
  `ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"`
  
3. [JavaSDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html) (puede ser la 6 o 7)

4. Maria DB: `brew install mariadb`
5. Tomcat7: `brew install tomcat`

6. JRuby: `brew install jruby` o mejor `rvm install jruby`


###Ubuntu
(comming soon...)