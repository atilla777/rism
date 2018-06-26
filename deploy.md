## Установка приложения RISM
### Для развертывания **RISM** должна быть выполнена установка следующих приложений
* Операционная система (ОС) **Linux** (рекомендуется *Ubuntu Server*, работа проверялась на версии [ubuntu-18.04-live-server-amd64](https://www.ubuntu.com/download/server/thank-you?country=RU&version=18.04&architecture=amd64)
* Систему управления версиями [git]( https://git-scm.com/)
* Сервер управления баз данных (СУБД) [Postgresql]( https://www.postgresql.org)
* Сервер [Redis]( https://redis.io/)
* [Node.js](https://nodejs.org/en/)
* Веб сервер [Nginx]( http://nginx.org/ru/)
* Система управлениями версиями языка программирования Ruby [RVM]( https://rvm.io/)
* [Ruby]( https://www.ruby-lang.org/en/)
* Систему управления зависимостями приложений Ruby [Bundler]( https://bundler.io/)
* Веб Фреймворк [Ruby on Rails](https://rubyonrails.org/)
* Ruby on Rails приложение [RISM](https://github.com/atilla777/rism)

Подразумевается, что установка приложения и управление его развертыванием (обновлениями) будут осуществляться с одного компьютера (сервера) через **Capistrano** с плагином **capistrano-local**.
Возможны и другие варианты (если вы подумаете, что делаете).
Минимальные требования к компьютеру (приблизительно)
* 1 процессор;
* 1 Гб ОЗУ;
* 15 ГБ HDD.

### 1 Этап – подготовка сервера и необходимой для работы приложения инфраструктуры
Установить Linux (можно установить, как виртуальную машину, например, в **VirtualBox**).
После установки Linux рекомендуется убедиться, что это действительно он
```bash
apt-get moo
```
Если вы в нужном месте с нужной ОС, можно продолжать (тем не менее установка возможна и на **Windows**, но данный вариант в этой инструкции не рассматривается).
Затем выполнить обновление системы
```bash
sudo apt-get update
sudo upt-get upgrade
```
Вместо процедуры описанной выше, можно установить обновления через пакет **unattended-upgrades**, и настроить автоматическую установку новых обновлений безопасности (тут стоит подумать, стоит ли ставить обновления автоматически, так как не всегда обновления могут проходить удачно для работы приложения) можно установить пакет ** unattended-upgrades** (скорее всего он у вас уже установлен) и произвести его настройку:
```bash
sudo apt-get install unattended-upgrades
sudo unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
```
В Linux создать пользователя **rism** и добавить его в группу **sudo** (в целях безопасности, в дальнейшем из этой группы его лучше удалить)
```bash
sudo adduser rism
sudo usermod -aG rism
```
Установить **git**
```bash
sudo apt-get install git
```
Установить **Postgresql** и пакеты от которых зависит для гем **pg** (подключение из Ruby к Postgresql):
> ! в libpq последняя буква — это маленькая Q

```bash
sudo apt-get install postgresql-9.5
sudo apt-get install libpq-dev
```
В Postgresql установить пароль для администратора (учетная запись **postgres**), создать пользователя приложения (**rism**) и базу данных приложения **rism_production**
```bash
sudo -i -u postgres
psql
```
```sql
alter user postgres with password ‘пароль’;
create user rism with superuser login password ‘пароль’;
create database rism_production;
\q
exit
```
Настраивается доступ к БД по паролю — для подключения типа **local** устанавливается метод **md5** (строка local all all md5 в файле ** pg_hba.conf **)
```bash
sudo vim /etc/postgres/9.5/pg_hba.conf
sudo systemctl restart postgresql
```
> ! последняя команда запрашивает пароль пользователя в ОС Linux

Установить**redis**
```bash
sudo apt-get install redis-server
```
Установить **nginx**
```bash
sudo apt-get install nginx
```
Установить **nodejs**
```bash
sudo apt-get install **nodejs**
```
Установить **RVM**
RVM устанавливается согласно инструкции с сайта
[https://rvm.io]( https://rvm.io)
```bash
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
source /home/rism/.rvm/scripts/rvm
```
Если установка ключей gpg завершится неудачей:
```bash
sudo pat-get install gnupg2
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
source /home/rism/.rvm/scripts/rvm
```
Установить **ruby**
> Приложение использует ruby 2.4, перед установкой Ruby рекомендуется узнать последнюю версию Ruby в ветке 2.4, ее и устанавливать

```bash
rvm install 2.4.4
```

Установить **Bundle**
> При установке Ruby гемов (gem install) команду **sudo** использовать не нужно

```bash
gem install bundle
```
Клонировать приложение RISM в среду разработки
```bash
mkdir dev
cd dev
git clone https://github.com/atilla777/rism
```
Далее необходимо в корне приложения создать файл
.env.development
скопировать в него строки из файла
.env.production
и указать в файле
.env.development
Пользователя (**rism**), пароль для пользователя базы данных и ключ от сервиса Shodan (для его получения необходимо зарегистрироваться на сайте [Shodan]( https://www.shodan.io/))
Создать базу данных и запустить приложение
```bash
cd rism
bundle
rails db:setup
rails db:migrate
rails db:seed
rails s
```
Перед командой запуска **sidekiq** необходимо задать переменную окружения с API ключом Shodan
```bash
SHODAN_KEY=ключ sidekiq
```
Приложение доступно по ссылке
http://localhost:3000
Пользователь – admin@rism.io
Пароль – pssword
> В принципе, на данном этапе, приложение уже можно использовать (хотя рекомендуется выполнить этап 2, для «правильного» управления релизами)

После выполнения всех описанных выше подготовительных операций, требующих выполнения sudo команд (например, установка зависимостей в ходе установки rvm) желательно запретить вход пользователю deploy по паролю (на период отладки или опытной эксплуатации приложения этого лучше не делать)
```bash
sudo passwd -l deploy
```
При этом пользователю **rism** необходимо дать возможность запуска nmap из под sudo без ввода пароля
```bash
sudo sudoers
```
```bash
Для этого должны присутствовать следующая строка
rism ALL=(ALL) NOPASSWD: /usr/bin/nmap
```
Проверяем, что нет лишних демонов, слушающих сетевые порты на внешних адресах
```bash
netstat -an --inet
```
