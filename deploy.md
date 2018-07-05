## Установка приложения RISM
В данном руководстве рассмотрено два варианта установки RISM - из готового образа виртуальной машины и "ручная" установка.
### Установка из образа виртуальной машины
Установить Oracle VirtualBox.

Скачать [образ](https://yadi.sk/d/N-HljDyT3Ymoet) виртуального сервера с приложением RISM (MD5 4f1b5a04b12bf86ede3c1e28a46b0ac6).

Запустить виртуальную машину.

После загрузки виртуальной машины, примерно через минуту запустится приложение RISM.

Приложение на виртуальном сервере прослушивает порт 80, для доступа к нему с локального хоста, на котором запущена виртуальная машина, используется проброс портов (виртуальная машина работает за NAT).
Поэтому для подключения к приложению необходимо перейти по ссылке:

http://localhost:8888

Пользователь – **admin@rism.io**

Пароль - **password**

Далее необходимо выполнить настройку сервера.

Подключиться к виртуальной машине локально или по SSH.

По умолчанию используются пароли **password** у следующих учетных записей (рекомендуется их сменить):

Учетная запись в Linux
* rism

Учетные записи в базе данных Postgresql
* postgres
* rism

Учетная запись в веб приложении RISM
* admin@rism.io
Версия приложения RISM в образе виртуальной машины может быть более станввм чем версия на github. По этой причине после входа в Linux выполнить обновление:
```bash
cd /home/rism/dev/rism
cap production deploy
```
Также надо сгенерировать секретный ключ приложения (используется для шифрования данных сессии в браузере клиента приложения):
```bash
cd /home/rism/dev/rism
rails secret
```
Далее необходимо в папке **/home/rism/prod/shared** отредактировать файл **.env.production**, указав в нем:
* сгенерированный секретный ключ приложения
* API ключ Shodan, если будет использоваться сканировние через Shodan
* пароль учетной записи пользователя Postgresql (**rism**), если вы его сменили
Перезапустить сервер веб приложения **puma** и сервер фоновых задач **sidekiq**:
```bash
sudo systemctl restart puma
sudo systemctl restart sidekiq
```
---
### Самостоятельная установка RISM
Для самостоятельного развертывания **RISM** должны быть установлены:
* Операционная система (ОС) **Linux** (рекомендуется **Ubuntu Server**, данная документация составлялась с использованием версии [ubuntu-18.04-live-server-amd64](https://www.ubuntu.com/download/server/thank-you?country=RU&version=18.04&architecture=amd64))
* Система управления версиями [git]( https://git-scm.com/)
* Сервер управления базами данных (СУБД) [Postgresql]( https://www.postgresql.org) (опробавано на версиях 9.6 и 10)
* Сервер хранилища [Redis]( https://redis.io/)
* Платформа JavaScript [Node.js](https://nodejs.org/en/)
* Веб сервер [Nginx]( http://nginx.org/ru/)
* Система управлениями версиями языка программирования Ruby [RVM]( https://rvm.io/)
* [Ruby]( https://www.ruby-lang.org/en/)
* Система управления зависимостями приложений Ruby [Bundler]( https://bundler.io/)
* Веб Фреймворк [Ruby on Rails](https://rubyonrails.org/)
* Ruby on Rails приложение [RISM](https://github.com/atilla777/rism)
* Система удаленного развертывания приложений [Capistrano](https://capistranorb.com/)

В данном руководстве подразумевается, что установка приложения и управление его развертыванием (обновлениями) будут осуществляться с одного компьютера (сервера) через **Capistrano** с плагином **[capistrano-local](https://github.com/komazarari/capistrano-locally)**.
Возможны и другие варианты (например, штатное использование Capistrano - развертывание с локального компьютера разработчика на удаленный сервер, но этот вариант пока не документирован).

Минимальные требования к компьютеру (приблизительно):
* 1 процессор;
* 1 Гб ОЗУ;
* 15 ГБ HDD.

### 1 Этап – подготовка сервера и необходимой для работы приложения инфраструктуры
Установить Linux (можно установить, как виртуальную машину, например, в **VirtualBox**).

После установки Linux рекомендуется убедиться, что это действительно он:
```bash
apt-get moo
```
Если вы в нужном месте с нужной ОС, можно продолжать (тем не менее установка возможна и на **Windows**, но данный вариант в этой инструкции не рассматривается).
Затем выполнить обновление системы:
```bash
sudo apt-get update
sudo upt-get upgrade
```
Вместо процедуры описанной выше, можно установить обновления через пакет **unattended-upgrades**, и настроить автоматическую установку новых обновлений безопасности можно установить пакет ** unattended-upgrades** (скорее всего он у вас уже установлен) и произвести его настройку (тут стоит подумать, надо ли ставить обновления автоматически, так как не всегда установка обновлений может проходить удачно для приложения):
```bash
sudo apt-get install unattended-upgrades
sudo unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
```
В Linux создать пользователя **rism** и добавить его в группу **sudo**:
```bash
sudo adduser rism
sudo usermod -aG sudo rism
```
Установить **git**:
```bash
sudo apt-get install git
```
Установить **Postgresql** и пакеты от которых зависит гем **pg** (подключение из Ruby к Postgresql):
> ! в libpq последняя буква — это маленькая Q

```bash
sudo apt-get install postgresql-9.5
sudo apt-get install libpq-dev
```
В Postgresql установить пароль для администратора (учетная запись **postgres**), создать пользователя приложения (**rism**) и базы данных приложения (**rism_development**, **rism_test**, **rism_production**):
```bash
sudo -i -u postgres
psql
```
```sql
alter user postgres with password 'пароль';
create user rism with superuser login password 'пароль';
create database rism_development;
create database rism_test;
create database rism_production;
\q
exit
```
> команды ```create database ...``` можно выполнить позже.

Настроить доступ к БД по паролю — для подключения типа **local** устанавливается метод **md5**:
```bash
sudo vim /etc/postgres/9.5/pg_hba.conf
```
В файле **pg_hba.conf** должна быть следующая строка:

**local     all       all       md5**

Перезапустить **Postgresql**:
```bash
sudo systemctl restart postgresql
```
> ! последняя команда запрашивает пароль пользователя в ОС Linux.

Установить **redis**:
```bash
sudo apt-get install redis-server
```
Установить **nginx**:
```bash
sudo apt-get install nginx
```
Установить **nodejs**:
```bash
sudo apt-get install nodejs
```
Установить **RVM**:
RVM устанавливается согласно инструкции с сайта - [https://rvm.io]( https://rvm.io).
Вот как это может выглядить:
```bash
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
source /home/rism/.rvm/scripts/rvm
```
Если установка ключей gpg завершится неудачей, то стоит попробывать следующее:
```bash
sudo pat-get install gnupg2
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
source /home/rism/.rvm/scripts/rvm
```
Установить **Ruby**:
> Приложение использует Ruby 2 с минорной версией 4 (то есть 2.4.X), перед установкой Ruby рекомендуется узнать последнюю патч-версию Ruby в ветке 2.4.x, ее и устанавливать.

```bash
rvm install 2.4.4
```
Установить **Bundle**:
> При установке Ruby гемов (gem install) команду **sudo** использовать не нужно.

```bash
gem install bundle
```
Клонировать приложение RISM в среду разработки:
```bash
mkdir dev
cd dev
git clone https://github.com/atilla777/rism
Установить Ruby on Rails и все зависимости:
```bash
cd rism
bundle
```
Создать базу данных, наполнить ее начальными данными и запустить приложение:
```bash
bundle
rails db:setup
rails db:migrate
rails db:seed
rails s
```
Далее необходимо в корне приложения отредактировать файл **.env.development**, указав в нем четную запись пользователя Postgresl (**rism**), ее пароль и API ключ Shodan (для его получения необходимо зарегистрироваться на сайте [Shodan]( https://www.shodan.io/)).

Перед командой запуска **sidekiq** необходимо задать переменную окружения с API ключом Shodan:
```bash
SHODAN_KEY=ключ sidekiq
```
После запуска приложение доступно по ссылке (оно запущено в режиме разработки и использует базу **rism_development**):
http://localhost:3000

Пользователь – admin@rism.io

Пароль – pssword
> В принципе, на данном этапе, приложение уже можно использовать для целей отладки или изучения системы (хотя рекомендуется выполнить этап 2, для «правильного» управления релизами и развертывания приложения в продуктивном режиме).

После выполнения всех описанных выше подготовительных операций, требующих выполнения sudo команд (например, установка зависимостей в ходе установки rvm) желательно запретить вход пользователю deploy по паролю (на период отладки или опытной эксплуатации приложения этого лучше не делать):
```bash
sudo passwd -l deploy
```
При этом пользователю **rism** необходимо дать возможность запуска nmap из под sudo без ввода пароля:
```bash
sudo visudo
```
Далее необходимо создать в открывшемся редакторе следующую строку:

**rism ALL=(ALL) NOPASSWD: /usr/bin/nmap**
> ! Указанная выше запись должна следовать за дргуими записями, в которых даются полномочия **sudo** для пользователя **rism**. То есть, если пользователь rism был добавлен в группу **sudo**, то эта запись должна следовать после строки

**%sudo   ALL=(ALL:ALL) ALL**

или (не рекомендуется в продуктивном режиме) разрешить запуск без ввода пороля всех команд:
```bash
rism ALL=(ALL) NOPASSWD:ALL
```
Проверяем, что нет лишних демонов, слушающих сетевые порты на внешних адресах (вопрос безопасности):
```bash
netstat -an --inet
```
### 2. Этап – подготовка инфраструктуры для развертывания приложения с помощью **Capistrano**

После подготовки инфраструктуры для работы приложения на сервере производится подготовка к развертыванию релизов приложения через **Capistrano**.
Так как на этапе 1 была выполнена команда bundle гем Capistrano уже установлен в системе.
Основные настройки Capistrano также уже имеются в папке клонированного через git приложения Rism (по сути клонирование на сервер приложения в окружении разработки было сделано для того, чтобы через bundle установить Capistrano и его настройки).
Итак, этап 2.
На сервере создать папки и файлы общие для всех релизов и не входящие в репозиторий (файлы с настройками специфичными для production серверов, секретами/паролями):
```bash
mkdir /home/rism/prod/shared
```
Скопировать настройки сервисов puma и sidekiq:
```bash
cp /home/dev/rism/puma.service /home/rism/prod/shared/puma.service
cp /home/dev/rism/sidekiq.service /home/rism/prod/shared/sidekiq.service
```
Скопировать файл с паролями и настройками:
```bash
cp /home/rism/dev/rism/.env.production /home/rism/prod/shared/.env.production
```
Сгенерировать секретный ключ:
```bash
rails secret
```
Далее необходимо в папке /home/rism/prod/shared отредактировать файл **.env.production**, указав в нем учетную запись пользователя Postgresl (**rism**), ее пароль, сгенерированный секретный ключ и API ключ Shodan.

Сделать общие для всех серверов предпродуктива и продуктива (stage и production) настройки в файле (если stage не используется (рекомендуемый вариант, для тех, кто не понимает, о чем идет речь), то соответствующие настройки stage можно не делать):

**config/deploy.rb**

Сделать специфические для серверов (stage и production) настройки в файлах (если stage не используется, то файлы для настроек stage можно не трогать):

**config/deploy/production.rb**

**config/deploy/staging.rb**

Для генерирования настроек **nginx** и **puma**, a также размещения их на сервере выполнить:
```bash
cap production puma:config
cap production puma:nginx_config
```
Проверяем и при необходимости кастомизируем настройки **nginx** на сервере:

**/etc/nginx/sites-available/rism_puma**
> ! в указанном выше файле может быть неверно указан параметр **proxy_set_header**, правильный вид настройки:
**proxy_set_header Host $http_host;**

Проверить, что все указанные выше папки и файлы имеются на сервере и выполнить развертывание релиза приложения:
```bash
cap production deploy:check
```

### 3. Этап – развертывание приложения с помощью **Capistrano**
Развернуть приложение (переход на использование нового релиза, при этом будет скачен код с основной ветки проекта на github):
```bash
cap production deploy
```
Загрузить в базу начальные значения (пользователя **admin** и его пароль):
```bash
cap production rails:rake:db:seed
```
Теперь приложение работает в продуктивном окружении (используется база rism_production) доступно по ссылке:
http://localhost:80

Пользователь – admin@rism.io

Пароль - **password**

### 4. Этап - донастройка и сопровождение

Для того, что бы приложение запускалось при включении (перезагрузке) компьютера, необходимо обеспечить автоматический запуск веб сервера приложения **puma** и (эти приложения были установлены при установке зависимостей RISM через команду **bundle**).
Сделать это можно через **systemd**.
Создать сервис **puma**:
```bash
 sudo ln -s /home/rism/prod/shared/puma.service /lib/systemd/system/
 systemctl daemon-reload
 sudo systemctl start puma
 sudo systemctl enable puma
 ```
 Создать сервис sidekiq.service:
 ```bash
 sudo ln -s /home/rism/prod/shared/sidekiq.service /lib/systemd/system/
 systemctl daemon-reload
 sudo systemctl start sidekiq
 sudo systemctl enable sidekiq
 ```
 Теперь управлять сервисами, обеспичивающими работу RISM, можно через systemd (Redis, Postgresql, Nginx были установлены через apt и уже находятся под управлением systemd), например:
```bash
sudo systemctl start puma
sudo systemctl restart nginx
sudo systemctl stop redis
sudo systemctl restart postgresql
``` 
Если с в работе приложения имеются проблемы, то искать их причины нужно в журналах событий и в списках запущенных сервисов (процессов).

Проблемы с запуском сервисов puma, sidekiq, Postgresql, nginx (сообщения systemd):
```bash
sudo systemctl status puma
sudo systemctl status sidekiq
sudo systemctl status postgresql
sudo systemctl status nginx
tail -n 100 /var/log/syslog
```
Ошибки в работе приложения:
```bash
tail -n 100 /home/rism/prod/shared/log/production.log
tail -n 100 /home/rism/prod/shared/log/rism_errors.log
```
Обновить код приложения:
```bash
cd /home/rism/dev/rism
cap production deploy
```
