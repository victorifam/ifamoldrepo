# Configuração inicial

### Subindo docker:
```
1 - Baixe a aplicação com o git clone https://gitlab.ifam.edu.br/diversos/portal-candidato-ifam.git.
2 - Para o ambiente de desenvolvimento execute o arquivo docker-compose-development, dentro do diretório src-candidato altere o nome do arquivo .env.development.exemple para .env, agora execute o comando, com sudo caso não tenha permissão, sudo docker-compose -f docker-compose-development -up -d --build, caso não queira que suba tudo, somente o necessário adicone no final do comando candidato.
3 - Para o ambiente de produção, crie um arquivo na raiz do projeto, fora do src-candidato, .env e adicione os parametros do modelo exemplo dentro de docker/.env.production.exemple, sendo os parametros comentados como opcional. Depois de criado o arquivo com os parametros, execute o comando sudo docker-compose -f docker-compose-production up -d --build. Em seguida deve ser realizado os comandos abaixo:
Depois de criado os container execute no terminal os comandos abaixo:

docker exec candidato chmod 775 -R /var/www
docker exec candidato chown www-data:www-data -R /var/www
docker exec -it candidato composer install
docker exec -it candidato php artisan migrate --database=pgsql-chef
docker exec -it candidato php artisan db:seed
Obs.: quando precisar realizar ajustes e seu usuário não tem permissão: docker exec candidato chown -R www-data:1000 /var/www

4 - Para abrir a aplicação de desenvolvimento, ela vai ter a ulr do ip ou localhost na porta 8823.
5 - Para o aplicação de produção, ela vai executar o nginx, com o nome do domínio passado na .env na raiz.
6 - No Ambiente de desenvolvimento vai ter os seguintes container, caso não restrinja somente ao container candidato, será, postgres, pgadmin, candidato, selenium. Para abrir o pgadmin, digite localhost:9080 com usuário sistemas@ifam.edu.br e senha sistemas.
7 - No ambiente de produção vai ter os seguintes container, pgsql, pgadmin, redis, nginx, candidato. Para abrir o pgadmin, digite a url mais a porta 9080 com usuário sistemas@ifam.edu.br e senha sistemas.

INFO: https://www.rosehosting.com/blog/how-to-install-laravel-on-ubuntu-22-04/
https://laravel.com/

```

### Ambiente desenvolvimento vscode ou outro framework de desenvolvimento:
```
Para o ambiente de desenvolvimento caso esteja usando o root o diretório talvez tenha que dar permissão com chmod 777 -R no projeto, se estiver usando outro usuário não terá necessidade de dar a permissão.
```

### Configurando ambiente desenvolvedor no vscode:
```
1 - Baixar e instalar o vscode https://code.visualstudio.com/download

2 - Opcional: instalar e configurar o php localmente https://blog.schoolofnet.com/como-instalar-o-php-no-windows-do-jeito-certo-e-usar-o-servidor-embutido/

3 - Configurando e instalando plugins vscode para laravel e php:
* PHP Extensio Pack
* Laravel Pack
* Emmet Live
* Git Extensio Pack
* Docker Extensio Pack
* Composer
* Remote Development
* Opcional: Tabnine, Dracula Official, Jinja

3 - Instalar o wsl, ubuntu 22, e configurar a conta de usuário root, https://learn.microsoft.com/pt-br/windows/wsl/install

4 - Configurar o docker e docker-compose ubuntu 22, https://cloudinfrastructureservices.co.uk/how-to-install-and-use-docker-compose-on-ubuntu-22-04/

5 - Depois de configurado, baixar o projeto no git, comando git clone https://gitlab.ifam.edu.br/diversos/portal-candidato-ifam.git

6 - Testar o ambiente localmente, seguir orientações no README do projeto.
```

### Comandos e classes:
```
1 - Configurar cidades em CitySeeder:
-----------------------------------------------------------------------------------------
Trecho comendato -> $states = (config('app.env') == 'production') ? State::all() : State::whereIn('slug',['SC','PR'])->get(); **/

Trecho utilizado ->$states =  State::all();
-----------------------------------------------------------------------------------------
2 - Caso o campo cidades não esteja copulado com informações execute o comando no docker, docker exec id_app/nome_app php artisan db:seed --class=CitySeeder, dê um refresh na página de cadastro.

-----------------------------------------------------------------------------------------
3 - Execute o comando no docker, docker exec id_app/nome_app php artisan db:seed --class=AdminUserSeeder, vá na página login e use 000.000.000-00 e senha  adm1q2w3e ou 999.999.999-99 gestor1q2w3e.

-----------------------------------------------------------------------------------------
4 - Execute o comando no docker para testar o envio de e-mail, classe SendTestEmailCommand, docker exec -it candidato php artisan email:send-test seu_email@email.com.

-----------------------------------------------------------------------------------------
5 - Execute o comando no docker para criar criar usuário e modalidade, classe SendTestEmailCommand, docker exec candidato php artisan db:seed, no ambiente desenvolvimento ele já sobe junto ao docker.
```