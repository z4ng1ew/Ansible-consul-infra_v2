
## Part 1. Удаленное конфигурирование узла через Ansible




## 1. Ansible preparation

### Создание трёх ВМ через Vagrant

Использован Vagrantfile для одновременного создания manager, node01, node02 на провайдере libvirt.
Vagrantfile не содержит shell-скриптов установки Docker — установка инструментов
будет выполнена через Ansible-плейбуки в следующих шагах.

![Список ВМ](screenshots/01-virsh-list.png)
*Скриншот 1: Три ВМ (manager, node01, node02) в статусе running*

![Vagrantfile](screenshots/02-vagrantfile.png)
*Скриншот 2: Содержимое Vagrantfile — без apt install docker*

### Подключение к manager и проверка сети с node01/node02

Со станции хоста подключаемся к manager по приватной сети 192.168.56.10. На manager сгенерирован
SSH-ключ ed25519 без passphrase, его публичная часть скопирована в `~/.ssh/authorized_keys`
на каждой ноде. Это позволяет Ansible с manager управлять нодами без ввода пароля.

```bash
# Команды для подключения по SSH к воркерам с manager:
ssh vagrant@192.168.56.11   # node01
ssh vagrant@192.168.56.12   # node02
```

![SSH с manager на ноды](screenshots/03-ssh-manager-to-nodes.png)
*Скриншот 3: Успешное подключение manager → node01 и manager → node02 по SSH-ключу*

### Inventory-файл

Файл `~/ansible/inventory.ini` на manager:

```ini
[nodes]
node01 ansible_host=192.168.56.11
node02 ansible_host=192.168.56.12

[nodes:vars]
ansible_user=vagrant
ansible_ssh_private_key_file=~/.ssh/id_ed25519
```

![Inventory](screenshots/05-inventory.png)
*Скриншот 5: Inventory-файл*

### Результат модуля ping

```bash
ansible -i inventory.ini all -m ping
```

![Ping module](screenshots/04-ansible-ping.png)
*Скриншот 4: Все ноды отвечают SUCCESS на ping-модуль Ansible*




















1. Подготовка Ansible




## 1) Имеется файл Vagrant для создания manager, узлов node01 и node02.
## 2) Файл Vagrant не запускает никаких скриптов оболочки для установки Docker или других инструментов, кроме Ansible.

![alt text](<imd/1/image copy.png>)
**Vagrantfile**

![alt text](imd/1/image.png)
**менеджер виртуальных машин**


![alt text](<imd/1/image copy 2.png>)
**видны три ВМ в статусе running: src_manager, src_node01, src_node02.**
**Vagrant создал три виртуальные машины**








![alt text](<imd/1/image copy 3.png>)
**Хост видит manager (192.168.56.10), node01 (192.168.56.11), node02 (192.168.56.12) по приватной сети**





## 3) На менеджере сгенерирован ключ для SSH-доступа; отчет содержит команды для SSH-доступа к рабочим узлам.


```
- Заходим на менеджер
ssh manager

- === Уже внутри менеджера ===
- Генерируем ключ без passphrase
ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519 -C "manager@vagrant"

- Просмотрим публичный ключ — пригодится для скриншота
cat ~/.ssh/id_ed25519.pub

- Выходим обратно на хост
exit
```

![alt text](<imd/1/image copy 4.png>)
**генерируем SSH-ключ на менеджере**



**раскладываем публичный ключ на ноды**

**Чтобы менеджер мог зайти на ноды без пароля, его публичный ключ нужно положить в authorized_keys каждой ноды.**

**Сначала с хоста копируем публичный ключ менеджера на ноды (потому что у нас они уже доступны через ssh):**


```
# Заходим на менеджер
ssh manager

# === Уже внутри менеджера ===

# Генерируем ключ без passphrase
ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519 -C "manager@vagrant"

# Просмотрим публичный ключ — пригодится для скриншота
cat ~/.ssh/id_ed25519.pub

# Выходим обратно на хост
exit
```


![alt text](<imd/1/image copy 5.png>)




**проверяем SSH с менеджера на ноды**


```
# С хоста через менеджер заходим на node01
ssh manager "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@192.168.56.11 'hostname && ip -br addr | grep 192.168.56'"

# То же для node02
ssh manager "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@192.168.56.12 'hostname && ip -br addr | grep 192.168.56'"
```


![alt text](<imd/1/image copy 6.png>)







## 3) На менеджере сгенерирован ключ для SSH-доступа; отчет содержит команды для SSH-доступа к рабочим узлам.

## 3.1. Генерация SSH-ключа на менеджере

![alt text](<imd/1/image copy 7.png>)
**файлы ключа (id_ed25519, id_ed25519.pub) и содержимое публичного ключа.**


## 3.2. SSH с менеджера на node01 без пароля

![alt text](<imd/1/image copy 8.png>)
**вывел node01 — без запроса пароля.**



## 3.3. SSH с менеджера на node01 без пароля
![alt text](<imd/1/image copy 9.png>)
**вывел node02 — без запроса пароля.**




## 3.4. sudo virsh list --all

![alt text](<imd/1/image copy 10.png>)
**все три ВМ работают**















## 4) Имеется результат выполнения модуля ping для Ansible.

![alt text](<imd/1/image copy 11.png>)
**ssh manager "cd ~/ansible && ansible -i inventory.ini all -m ping"**



## 5) Имеется файл инвентаризации.
![alt text](<imd/1/image copy 12.png>)







## 6. Скопировал на manager docker-compose файл и исходный код микросервисов. (Используя проект из папки src и docker-compose файл из предыдущей главы.

**docker-compose.yml и исходный код микросервисов скопированы с хоста на manager через scp:**

```bash
scp docker-compose.yml manager:~/
scp -r services manager:~/
``` 
![alt text](<imd/1/image copy 13.png>)









2. Плейбук Ansible и тесты

1) Существует плейбук, который выполняет команду apt update, устанавливает Docker, Docker Compose, копирует файл Compose из менеджера и развертывает микросервисное приложение; этот плейбук выполняет эти задачи.

![alt text](<imd/1/image copy 14.png>)
**ssh manager "cd ~/ansible01 && ansible-playbook -i inventory/hosts.ini playbook.yml -v" 2>&1 | tail -30 - сборка локально всех 9ти сервисов   -  ok=20 changed=6 unreachable=0 failed=0**


![alt text](<imd/1/image copy 15.png>)
**Все 9 контейнеров UP, failed=0!**

![alt text](<imd/1/image copy 16.png>)
**ssh node01 "sudo docker ps --format 'table {{.Names}}\t{{.Status}}'" - Все 9 контейнеров UP**
**Ansible-плейбук успешно развернул все 9 контейнеров на сервере node01.**



![alt text](<imd/1/image copy 17.png>)
**ssh node01 "sudo docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"**



![alt text](<imd/1/image copy 18.png>)
**curl -s http://192.168.56.11:8081 | head -10**
**Сервисы отвечают**



![alt text](<imd/1/image copy 19.png>)
**curl -s http://192.168.56.11:8087 | head -5**
**Сервисы отвечают**

> Это значит:
    Gateway-service работает и отвечает
    Просто корневой путь / не имеет обработчика — 404 это ожидаемое поведение
    API доступно по конкретным эндпоинтам, не по /
>

>API gateway защищён JWT-токенами. Без токена возвращает 404/401. Именно для этого нужны Postman тесты — они сначала логинятся, получают токен, потом делают запросы.

Проверим что session-service работает напрямую:
>


![alt text](<imd/1/image copy 21.png>)
**curl -s http://192.168.56.11:8081/users | head -10**
**отвечает**

```
(base) s@fedora:~/Ansible-consul-infra/src$ curl -s http://192.168.56.11:8081/users | head -10
{
  "_embedded" : {
    "users" : [ {
      "name" : "User",
      "userUid" : "6d2cb5a0-943c-4b96-9aa6-89eac7bdfd2b",
      "password" : "$2a$10$qgBcax6zQLYlWoK6R.cjDOGkH2xOjllmc7iEvBe1HIHt5ylZFo0b.",
      "_links" : {
        "self" : {
          "href" : "http://192.168.56.11:8081/users/1000"
        },
(base) s@fedora:~/Ansible-consul-infra/src$ 
```



![alt text](<imd/1/image copy 20.png>)
**ssh manager "cd ~/ansible01 && cat playbook.yml" | head -30**
**Плейбук запускается с manager**





2) Результаты тестов Postman представлены в виде скриншота.

![alt text](<imd/1/image copy 22.png>)
**Все результаты  postman запросов 200/201**

3) Существует три роли для развертывания приложения, развертывания сервера Apache и развертывания базы данных Postgres; первая роль назначается в файле инвентаризации первому узлу, а две другие — второму узлу.

![alt text](<imd/1/image copy 23.png>)

![alt text](<imd/1/image copy 24.png>)
**node02: ok=15 failed=0**
**Apache, PostgreSQL, таблица с 3 записями**


![alt text](<imd/1/image copy 25.png>)
**Apache в браузере**
>
http://192.168.56.12/

Hello from node02!

Apache is running on node02 (192.168.56.12)
>





4) Все файлы Ansible находятся в папке src\ansible01.











        2. Ansible playbook and tests

    1) There is a playbook that performs apt update, installs Docker, Docker Compose, copies the Compose file from the manager, and deploys the microservice application; this playbook performs these tasks.
    2) The results of the Postman tests are provided as a screenshot.
    3) There are three roles for application deployment, apache server deployment, and Postgres database deployment; the first role is assigned in the inventory file to the first node and the other two to the second node.
    4) All files for ansible are located in src\ansible01.




        3. Consul configuration files

    1) There are configuration files for the server and the client with the advertise_addr specifying the network interface directed to the internal Vagrant network.




        4. Consul roles

    1) The playbook in src\ansible02 is written to run the roles: install_consul_server, install_consul_client, install_db and install_hotels_service.
    2) The install_consul_server role installs the consul server.
    3) The install_consul_client role installs the consul client.
    4) The install_db role installs Postgres and creates the hotels_db database.
    5) The install_hotels_service opens jdk-8-jdk role, copies the source code of the service, creates global environment systems, runs the built JAR file with the command.
    6) The results of the manual CRUD tests are provided as a screenshot.
















5. Сформировать три роли: 
   - роль application выполняет развертывание микросервисного приложения при помощи docker-compose;
   - apache устанавливает и запускает стандартный apache сервер;
   - postgres устанавливает и запускает postgres, создает базу данных с произвольной таблицей и добавляет в нее три произвольные записи. 
   - Назначить первую роль node01 и вторые две роли node02, проверить postman-тестами работоспособность микросервисного приложения, удостовериться в доступности postgres и apache-сервера. Для Apache веб-страница должна открыться в браузере. Что касается PostgreSQL, необходимо подключиться с локальной машины и отобразить содержимое ранее созданной таблицы с данными.

6. Созданные в этом разделе файлы разместить в папке `src\ansible01` в личном репозитории.

## Part 2. Service Discovery

Теперь перейдем к обнаружению сервисов. В этой главе тебе предстоит сымитировать два удаленных сервиса — api и БД, и осуществить между ними подключение через Service Discovery с использованием Consul.

### Задание

1. Написать два конфигурационных файла для consul (информация по consul в материалах):
   - consul_server.hcl:
      - настроить агент как сервер;
      - указать в advertise_addr интерфейс, направленный во внутреннюю сеть Vagrant;
   - consul_client.hcl:
      - настроить агент как клиент;
      - указать в advertise_addr интерфейс, направленный во внутреннюю сеть Vagrant.

2. Создать с помощью Vagrant четыре машины: consul_server, api, manager и db.
   - Прокинуть порт 8082 с api на локальную машину для доступа к пока еще не развернутому api.
   - Прокинуть порт 8500 с consul_server для доступа к ui consul. 

3. Написать плейбук для ansible и четыре роли: 
   - install_consul_server, которая:
      - работает с consul_server;
      - копирует consul_server.hcl;
      - устанавливает consul и необходимые для consul зависимости;
      - запускает сервис consul;
   - install_consul_client, которая:
      - работает с api и db;
      - копирует consul_client.hcl;
      - устанавливает consul, envoy и необходимые для consul зависимости; 
      - запускает сервис consul и consul-envoy;
   - install_db, которая:
      - работает с db;
      - устанавливает postgres и запускает его;
      - создает базу данных `hotels_db`;
   - install_hotels_service, которая:
      - работает с api;
      - копирует исходный код сервиса;
      - устанавливает `openjdk-21-jdk`;
      - создает глобальные переменные окружения:
         - POSTGRES_HOST="127.0.0.1";
         - POSTGRES_PORT="5432";
         - POSTGRES_DB="hotels_db";
         - POSTGRES_USER="<имя пользователя>";
         - POSTGRES_PASSWORD="<пароль пользователя>";
      - запускает собранный jar-файл командой `java -jar <путь до hotel-service>/hotel-service/target/<имя jar-файла>.jar`.

4. Проверить работоспособность CRUD-операций над сервисом отелей. В отчете отобразить результаты тестирования.

5. Созданные в этом разделе файлы разместить в папках `src\ansible02` и `src\consul01` в личном репозитории.