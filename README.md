# Infrastructureascode
deploy-puma-server gcloud compute instances create --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --metadata startup-script-url=https://gist.githubusercontent.com/Nonamed123/1e8afd0c2abab59994493d5e4506ee94/raw/00835e49064eb586dc251679bb592893247f3c44/Script.sh --zone=europe-west1-b reddit-app #This variant work with Google Cloud SDK Shell gcloud compute instances create --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --metadata-from-file startup-script=Startup.sh --zone=europe-west1-b reddit-app #This variant work with Cloud Shell and use file into server https://gist.github.com/Nonamed123/1e8afd0c2abab59994493d5e4506ee94 #This source for work script gcloud compute instance-templates create reddit-app --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --tags puma-server --machine-type=g1-small --restart-on-failure --metadata startup-script='wget -O - https://gist.githubusercontent.com/Nonamed123/1e8afd0c2abab59994493d5e4506ee94/raw/4855c1fc2b0007ab619ba587309590bb540377c0/Script.txt | bash' #This variant use template, this vork variant Three varian use for application image: about puma as service, next puma scripts with rc.local and puma start with init.d use skeleton: use two varinat esay andmore dificult. gcloud compute instances create reddit-app --image-family reddit-full --zone=europe-west1-b --tags puma-server --machine-type=g1-small --restart-on-failure - for first varian gcloud compute instances create reddit-app --image-family reddit-apper --zone=europe-west1-b --tags puma-server --machine-type=g1-small --restart-on-failure - for second variant gcloud compute instances create reddit-app --image-family reddit-dem --zone=europe-west1-b --tags puma-server --machine-type=g1-small --restart-on-failure - for third variant gcloud compute instances create reddit-app --image-family reddit-test --zone=europe-west1-b --tags puma-server --machine-type=g1-small --restart-on-failure
HW11
Add playbook for configure app-server and db-server in one host
Add playbook for configure app-serve and db-server for other hosts
Add file gce.py for chech ip, this dynamic uinventory

#Homework 12 Ansible работа с ролями.#

Создали две роли - roles/db и roles/app, для конфигурирования бд и приложения.

Роли вызываются плейбуками playbooks/app.yml и playbooks/db.yml. Деплоится с помощью playbooks/deploy.yml

Так же в приложении используем роль из ansible-galaxy - jdauphant.nginx

Для создания структуры роли по общепринятому формату используется команда:

ansible-galaxy init <имя роли>
Общепринятая структура для ролей:

db
├── README.md
├── defaults
│   └── main.yml
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── tasks
│   └── main.yml
├── tests
│   ├── inventory
│   └── test.yml
└── vars
 └── main.yml
Для создания окружений используется практика папки environments, со следующей структурой:

environments
├── prod
│   ├── group_vars
│   │   ├── all
│   │   ├── app
│   │   ├── db
│   ├── inventory
└── stage
    ├── group_vars
    │   ├── all
    │   ├── app
    │   ├── db
    └── inventory
Где мы указываем хосты и переменные.

Запускаются плейбуки командами:

Для prod

ansible-playbook -i environments/prod/inventory playbooks/site.yml
Для stage инвентори используется по умолчанию

ansible-playbook playbooks/site.yml
Параметризация окружений.
Для задания переменных stage-конфигурации создан каталог групповых переменных environments/stage/group_vars. В каталог group_vars добавлен файл с переменными для группы серверов приложений "app", и внего перенесены переменные из плейбука "app.yml". Из плейбука раздел vars удален. Аналогичным образом настроены преременные группы "db". Скопирован каталог group_vars из окружения stage в prod. В каталоге изменено занчение переменной env на prod. Выводим информацию об исползуемом окруженийй. В ролях задано значение по-умолчанию для переменной "env". Тат же заданы таски на вывод значения переменной "env" во время исполнения роли.

Организация рабочего каталога ansible.
Все плейбуки перенесены в новый каталог playbooks. Все ненужные файлы и каталоги преренесены в новый каталог old. В конфиге ansible.conf добавлено несколько директив: для явного задания каталога с ролями, для отключения формирования файлов *.retry и для вывода информации об изменениях в модифицируемых файлах (раздел [diff]). Поочередно проверены конфигурирование stage и prod окружений с помощью ansible. Доступ к приложению в обоих случаях получен.

Роли сообщества.
В оба окружения добавлен файл зависимостей requiremenst.yml c ролью из ansible galaxy "jdauphant.nginx". Данная роль проинсталирована и добавлена в файл .gitignore репозитория, чтобы не комитить её.

Самостоятельное задание.
Для самостоятельного задания в конфиг terraform было добавлено открытие порта 80 на сервер приложения при помощи ресурса управления правилами фаервола. Для этого в модуль конфигурации приложения добавлен ресурс "google_compute_firewall firewall_nginx" и соответствующие переменные используемые в нем. Далее инфраструктура была развернута с использованием данной конфигурации. В плейбук app.yml добавлен вызов комьюнити-роли jdauphant.nginx, переменные определенные для роли и инвентори файл были отредактированы. Инфраструктура сконфинурирована с использованием обновленного сценария ansible. После чего к приложению можно было обратиться через прокси сервер настроенный на 80 порту сервера приложения из Интернет. По окончании развертывания и тестирования инфраструктуар была уничтожена.

Homework 11
Ansible работа с плейбуками.

Деплой бд и приложения, используя теги, хосты из инвентори, хендлеры и настраивая packer для работы с ansible.

Для проверки плейбука используется --check Для ограничения хостов для работы используется --limit

Настройка БД:

ansible-playbook reddit_app_one_play.yml --limit db --tags db-tag
или

ansible-playbook reddit_app_multiple_plays.yml --tags db-tag
Настройка приложения:

ansible-playbook reddit_app_one_play.yml --limit app --tags app-tag
или

ansible-playbook reddit_app_multiple_plays.yml --tags app-tag
Деплой приложения:

ansible-playbook reddit_app.yml --limit app --tags deploy-tag
или

ansible-playbook reddit_app_multiple_plays.yml --tags deploy-tag
Настройка БД, приложения и деплой:

ansible-playbook site.yml
Packer использует плейбуки для конфигурации в образе бд и приложения (packer_db.yml и packer_app.yml) в ansible/db.json и ansible/app.json

/bin/packer build -var-file=packer/variables.json ansible/db.json
/bin/packer build -var-file=packer/variables.json ansible/app.json
Задача со *

Использовал gce.py

Дня настройки dynamic inventory исполоьзовал инструкцию http://docs.ansible.com/ansible/latest/guide_gce.html

Для генерации ключа json использовал инструкцию https://cloud.google.com/video-intelligence/docs/common/auth

Для работы gce.py использовал secrets.py

Проверка через:

ansible/gce.py

{"tag_reddit-db": ["reddit-db"], "europe-west1-b": ["reddit-app", "reddit-db"], "_meta": {"stats": {"cache_used": false, "inventory_load_time": 0.5437030792236328}, "hostvars": {"reddit-app": {"gce_uuid": "c8cad8a1d017217b968780d9af7bfba7a2cac57b", "gce_public_ip": "35.195.91.236", "ansible_ssh_host": "35.195.91.236", "gce_private_ip": "10.132.0.3", "gce_id": "2230212979571038950", "gce_image": "reddit-app-base-1516019474", "gce_description": null, "gce_machine_type": "g1-small", "gce_subnetwork": "default", "gce_tags": ["reddit-app"], "gce_name": "reddit-app", "gce_zone": "europe-west1-b", "gce_status": "RUNNING", "gce_network": "default", "gce_metadata": {"sshKeys": "appuser:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTEFAN4jd0lb+FrJZezqWH7uG5/UFM6YDvknHmzbX45lsIRLkuxYhFAQ2Oh9PPQS3NrCRfcWhJzS9aPtVz2tsbLZp7H8JTjtbdvLczhemtJ40XouSDqWaQ760P/S9ANZna0Osb7wIs0RQ4fLmr7xckujw8x2lfsIfOgquTXkh7fFPYuuchbuypXMnf/Vt4O5UGph3rHeDPRQU75jfadx4JgGtQKR3wpbDQmhLz+JjqMpggDn1DkmJiHTEbPDTeSgoeK3kj90MzYo82L2tl1sQzZ/IMMlkAG76xoAYIYLVgFCUitgLZ/T0jjmDNqBfTX2ZOCKLqvaAjI+P2eAlHf0Dl derokhin@lanit.ru\n\nderokhin:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTEFAN4jd0lb+FrJZezqWH7uG5/UFM6YDvknHmzbX45lsIRLkuxYhFAQ2Oh9PPQS3NrCRfcWhJzS9aPtVz2tsbLZp7H8JTjtbdvLczhemtJ40XouSDqWaQ760P/S9ANZna0Osb7wIs0RQ4fLmr7xckujw8x2lfsIfOgquTXkh7fFPYuuchbuypXMnf/Vt4O5UGph3rHeDPRQU75jfadx4JgGtQKR3wpbDQmhLz+JjqMpggDn1DkmJiHTEbPDTeSgoeK3kj90MzYo82L2tl1sQzZ/IMMlkAG76xoAYIYLVgFCUitgLZ/T0jjmDNqBfTX2ZOCKLqvaAjI+P2eAlHf0Dl derokhin@lanit.ru\n"}}, "reddit-db": {"gce_uuid": "004e3cb7bff0411ca7b124eaae979339949ce19d", "gce_public_ip": "35.205.232.161", "ansible_ssh_host": "35.205.232.161", "gce_private_ip": "10.132.0.2", "gce_id": "8606252764123372817", "gce_image": "reddit-db-base-1516019160", "gce_description": null, "gce_machine_type": "g1-small", "gce_subnetwork": "default", "gce_tags": ["reddit-db"], "gce_name": "reddit-db", "gce_zone": "europe-west1-b", "gce_status": "RUNNING", "gce_network": "default", "gce_metadata": {"sshKeys": "appuser:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTEFAN4jd0lb+FrJZezqWH7uG5/UFM6YDvknHmzbX45lsIRLkuxYhFAQ2Oh9PPQS3NrCRfcWhJzS9aPtVz2tsbLZp7H8JTjtbdvLczhemtJ40XouSDqWaQ760P/S9ANZna0Osb7wIs0RQ4fLmr7xckujw8x2lfsIfOgquTXkh7fFPYuuchbuypXMnf/Vt4O5UGph3rHeDPRQU75jfadx4JgGtQKR3wpbDQmhLz+JjqMpggDn1DkmJiHTEbPDTeSgoeK3kj90MzYo82L2tl1sQzZ/IMMlkAG76xoAYIYLVgFCUitgLZ/T0jjmDNqBfTX2ZOCKLqvaAjI+P2eAlHf0Dl derokhin@lanit.ru\n\nderokhin:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTEFAN4jd0lb+FrJZezqWH7uG5/UFM6YDvknHmzbX45lsIRLkuxYhFAQ2Oh9PPQS3NrCRfcWhJzS9aPtVz2tsbLZp7H8JTjtbdvLczhemtJ40XouSDqWaQ760P/S9ANZna0Osb7wIs0RQ4fLmr7xckujw8x2lfsIfOgquTXkh7fFPYuuchbuypXMnf/Vt4O5UGph3rHeDPRQU75jfadx4JgGtQKR3wpbDQmhLz+JjqMpggDn1DkmJiHTEbPDTeSgoeK3kj90MzYo82L2tl1sQzZ/IMMlkAG76xoAYIYLVgFCUitgLZ/T0jjmDNqBfTX2ZOCKLqvaAjI+P2eAlHf0Dl derokhin@lanit.ru\n"}}}}, "tag_reddit-app": ["reddit-app"], "35.195.91.236": ["reddit-app"], "reddit-db-base-1516019160": ["reddit-db"], "status_running": ["reddit-app", "reddit-db"], "g1-small": ["reddit-app", "reddit-db"], "reddit-app-base-1516019474": ["reddit-app"], "10.132.0.3": ["reddit-app"], "10.132.0.2": ["reddit-db"], "network_default": ["reddit-app", "reddit-db"], "35.205.232.161": ["reddit-db"]}
ansible all -i ansible/gce.py -m ping

reddit-app | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
reddit-db | SUCCESS => {
    "changed": false,
    "ping": "pong"
}


Homework 10
Работа с ansible

Все хосты на которые ansible может слать команды указываются в файле inventory. Он может быть формата ini, yml, json (кроме ini только с версии ansible 2.4) Команды отправляются обычно через модули в формате:

ansible <хост> -i <путь до файла инвентори> -m <модуль>
ansible appserver -i ./inventory -m ping
Чтобы не указывать каждый раз какой инвентори файл будет запущен, а так же имя пользователя и пусть до ключа в каждой строке хоста инвентори можно задать настройки в конфигурации - ansible.cfg

Модули кроме shell и command проверяют состояние системы\файла и не будут выполнять лишнюю работу по второму разу.

Homework 9
Модули в terraform

Создал 3 модуля - db, app, vpc db - модуль для создание виртуалки и настройки на ней бд mongodb app - модуль для создания виртуалки и настройки на ней reddit с подключением к mongodb vpc - модуль для настройки подключения по ssh

Создал два варианта настройки виртуалок - stage и prod stage - создание среды с возможностью подключаться со всех ip адресов prod - создание среды с возможностью подключаться только с 46.39.56.7

Настроил еще один внешний модуль stage для хранения state в гугле

Задача со *

Настроил хранение стейт файла в гугловском хранилище через

terraform {
  backend "gcs" {
    bucket = "reddit-terraform"
    prefix = "stage"
  }
}
Задача со **

Сделал деплой приложения. Сначала перенастраивается база данных (/etc/mongod.conf), для возможности удаленных подключений. Потом заливается приложение на сервер приложения с внутреним ip от бд в конфигурции.

data "template_file" "pumaservice" {
  template = "${file("../files/puma.service")}"

  vars {
    host_db = "${var.host_db}"
  }
}
provisioner "file" {
  content     = "${data.template_file.pumaservice.rendered}"
  destination = "/tmp/puma.service"
}
Homework 8
Работа с terraform

Если работа идет на новой машине, а не последовательно после задачния с packer, то необходимо авторизовываться с гуглом: gcloud auth application-default login

Есть шаблон файла с переменными: terraform.tfvars.example Необходимо перед работой сделать на основе него файл terraform.tfvars с уже нормальными параметрами.

Запуск идет через команды:

terraform plan # план работ
terraform apply # выполнение работ
Дополнительно:

terraform destroy # удалить указанные в конфиге виртуалки
terraform fmt # отформатировать файлы
Задача со * У меня выходит, что terraform имеет более высокий приоритет и переписывает состояние виртуалки под свою конфигурацию, не дополняя, а синхронизируя с конфигами.

Когда я изменил юзера на appuser1, то первоначальный перестал подключаться.
Двух (и более) пользователей terraform добавляет без проблем, но запись не очень удобного формата:
sshKeys = "${var.user}:${file(var.public_key_path)}\nappuser1:${file(var.public_key_path)}"
Когда я добавил нового юзера и его ключ через веб, при переконфигурировании тераформ его подчистил.
Задача со **

Сделал поднятие двух нод через count
Балансировку не осилил пока, мог бы сделать через создание еще одной ноды с nginx, но думаю зада была как раз в том, чтобы основоить встренные в гугл механизм балансировки. Посмотрю на праздинках.

Homework 7
Работа с packer

Аутентификация с гугловским облаком: gcloud auth application-default login

Запуск packer для дефолтного образа:

packer build -var-file=variables.json ubuntu16.json
Запуск packer и gcloud для полного образа:

packer build -var-file=variables.json immutable.json

gcloud compute instances create reddit-app\
  --image-family reddit-full \
  --tags puma-server \
  --restart-on-failure

Сборка идет с помощью скриптов:

install_ruby.sh install_mongodb.sh deploy.sh

Чтобы reddit запускался автоматом при старте виртуалки положил в него сервис файл - deamon и настроил на автозапуск

Homework 6
Скрипты для установки:

deploy.sh install_mongodb.sh install_ruby.sh

Startup.sh # чтобы выкачать удаленно и запустить

create.sh # чтобы не вбивать команду gcloud

Добавил пару тестиков для прроверки развертывания На сервере в папке /home/reddit/install.log

Строка запуска:

gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=https://raw.githubusercontent.com/Otus-DevOps-2017-11/nefariusmag_infra/Infra-2/Startup.sh
Homework 5
ssh -A 35.198.103.134 'ssh 10.156.0.3' alias internalhost="ssh -A 35.198.103.134 'ssh 10.156.0.3'"

Хост bastion, IP: 35.198.103.134, внутр. IP: 10.156.0.2. Хост: someinternalhost, внутр. IP: 10.156.0.3
