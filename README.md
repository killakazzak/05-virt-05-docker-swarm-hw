# Домашнее задание к занятию 6. «Оркестрация кластером Docker контейнеров на примере Docker Swarm»

#### Это задание для самостоятельной отработки навыков и не предполагает обратной связи от преподавателя. Его выполнение не влияет на завершение модуля. Но мы рекомендуем его выполнить, чтобы закрепить полученные знания. Все вопросы, возникающие в процессе выполнения заданий, пишите в учебный чат или в раздел "Вопросы по заданиям" в личном кабинете.

---

## Важно

**Перед началом работы над заданием изучите [Инструкцию по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**
Перед отправкой работы на проверку удаляйте неиспользуемые ресурсы.
Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.
Подробные рекомендации [здесь](https://github.com/netology-code/virt-homeworks/blob/virt-11/r/README.md).

[Ссылки для установки открытого ПО](https://github.com/netology-code/devops-materials/blob/master/README.md).

---

## Задача 1

Создайте ваш первый Docker Swarm-кластер в Яндекс Облаке.
Документация swarm: https://docs.docker.com/engine/reference/commandline/swarm_init/
1. Создайте 3 облачные виртуальные машины в одной сети.
2. Установите docker на каждую ВМ.
3. Создайте swarm-кластер из 1 мастера и 2-х рабочих нод.

4. Проверьте список нод командой:
```
docker node ls
```

## Решение Задача 1

Настройки yandex cloud

```bash
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```
Получение  OAUTH-токена https://yandex.cloud/en/docs/iam/concepts/authorization/oauth-token

```bash
yc init
yc config list
```
Создание service account

yc iam service-account --folder-id <ID_каталога> list

yc iam key create --service-account-name <account_name> --output key.json --folder-id <ID_каталога>

Настройка terraform

```bash
cat <<EOF >> ~/.terraformrc
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
EOF
```

```bash
cat <<EOF >> /root/05-virt-05-docker-swarm-hw/meta.txt
users:
  - name: tenda
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
EOF
```
```bash
cat <<EOF >> /root/05-virt-05-docker-swarm-hw/ssh-keys.txt
tenda:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHB9X8NFfwcRKgcuSkzaqq1LCpplIhFsHNu54WnZhzAg tenda
EOF
```
```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Настройка ansible

```bash
 ansible-playbook -i inventory.yaml  docker_swarm_setup.yml
```
Не удалось подключить worker-ноды с помощью ansible. Возникла ошибка



Поэтому подключал ноды в ручном режиме...

```bash
docker node ls
```


## Задача 2 (*) (необязательное задание *).
1.  Задеплойте ваш python-fork из предыдущего ДЗ(05-virt-04-docker-in-practice) в получившийся кластер.
2. Удалите стенд.


## Задача 3 (*)

Если вы уже знакомы с terraform и ansible  - повторите практику по примеру лекции "Развертывание стека микросервисов в Docker Swarm кластере". Попробуйте улучшить пайплайн, запустив ansible через terraform синамическим инвентарем.

Проверьте доступность grafana.

Иначе вернитесь к выполнению задания после прохождения модулей "terraform" и "ansible".

