#Deploying 
>In order to be able to deploy on both Windows and Linux a Tomcat7 deploy was selected. Heroku was used as a test bed.

Para hacer el deploy que pueda funcionar en Windows y en Linux se selecionó JRuby/Java/Tomcat7 y como prueba Heroku. 

Para hacer el deploy a tomcat primero este tiene que estar ready para un aplicación Rails 4.

Sigua las instruciones en [Instruciones para Tomcat](tomcat_instructions.md "Instruciones para Tomcat") las cuales sirven para Linux o Windows. 

Despues de preparada la maquina para el deploy en la maquina de 'development' corra los comandos para generar el war file.

Translade el war file al file <TOMCAT_HOME>/webapps y corra el tomcat server. 
>Ubuntu: `sudo service tomcat7 {stop|start|restart}`  
>Windows: Apache Tomcat>Monitor Tomcat -- General Tab >> Start

Esto debe crear y poblar un folder en en webapps con el mismo nombre del warfile. 
Esto puede tomar bastante tiempo...

# War file
La generación automatica del warfile es usando el gem Warble version 1.4.0 o mas reciente. Pero esta gema tiene ciertos 'gotchas' entre ellos que los file como web.xml que auto genera pueden contener caracteres chatarra al final, por lo tantos deben ser incluidos manualmente en el projecto para que Warble los cópie en vez de generarlos. 

Warble utiliza el file `config/warble.rb` si existe para su configuración.
Se utilizan las siguientes configuraciones:
```
config.jar_name = "rucpocver#{Time.now.to_i}"
config.excludes = FileList["**/*/*.box"]
config.includes = FileList["Rakefile"]
config.webserver = 'jenkins-ci.winstone'
config.dirs = %w(app config db lib log vendor tmp bin public)
config.bundle_without = []
  #config.features = %w(executable)
```

La primera crea la el nombre del jar con la añadidura del tiempo para evitar conflictos de nombre.  
La segunda remueve cualquier file .box para deploys de torquebox.

Todas las opciones `config.webxml` son removidas para crearlas en el web.xml ya hecho. Pero si fuera a generar el primero (siempre y cuando chequeé que el file este bien) estas son las opciones:
```
config.webxml.rails.env = 'production'
config.webxml.jruby.compat.version = "2.0"
config.webxml.jruby.min.runtimes = 1
config.webxml.jruby.max.runtimes = 1 
```

Tambien se le puede añadir esta linea al `web.xml` para darle un nombre a la aplicación en el dashboard de Tomcat
`<display-name>Registro de Cuentas por Cobrar</display-name>`

- Para crear el war file vaya al directorio del app y corra:  
    `warble`  

- Para ver las opciones de warble use `warble -T`

#Trouble shooting

1. Me sale un error de JRuby version...![Error Page for JRuby version](NewVersionofJRUBY.png)
>Este error es probablemente porque un gem llamado jruby-jars que contiene el runtime de jruby esta en la version pasada corra `bundle update jruby-jars` en la maquina de development y corra warble again. 

2. No corre Tomcat7 en Windows pero funciona en Linux
>Asegurese que no haya ningún tipo de espacio (' ') o caracter especial (como #) en el PATH de tomcat. Por ejemplo el sugerido es `C:\ApacheTomcat\` pero este que funciona el Linux no funciona en windows: 'ApacheTomcta#7' o uno con espacios 'Apache Tomcat'. 

3. Apache Tomcat sube pero la aplicación no corre
>Creaste la base de datos? Corre `jruby -S rake db:migrate RAILS_ENV=production` por si acaso.    

4. Algo raro con los war files...
>Warble tiene un bug que genera caracteres chatarra al final de files como: `web.xml` si ese el caso puede eliminar estos caracteres chatarra o mejor y sugerido crear un web.xml file en el directorio en la maquina 'development' para que Warble lo copie y no lo genere. 