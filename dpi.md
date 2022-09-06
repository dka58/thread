        
&nbsp;&nbsp;&nbsp;&nbsp;**Простая настройка обхода DPI**
 
GoodbyeDPI для Windows: <br>
- Скачиваешь: https://cdn-topersoft.nl/download/launchergdpi.php или https://topersoft.com/programs/launchergdpi
- Извлекаешь куда-нибудь содержимое архива, запускаешь Launcher for GoodbyeDPI.exe из папки x86_64.
- Нажимаешь Быстрый шаблон настроек: 6.
- Ставишь галочку у Обход блокировок только для доменов из списка (Blacklist).
- Кликаешь Запустить обход блокировок.
- Отписываешься в тред, если не работает. Ваше мнение очень важно для нас. [spoiler]Не то чтобы сильно.[/spoiler]

Посложнее здесь: https://github.com/ValdikSS/GoodbyeDPI

zapret+dnscrypt для Linux (простая настройка относительно простоты линукса): 
- Ставим dnscrypt-proxy. Это DNS-клиент, позволяющий пользоваться зашифрованными DNS протоколами.
- Чтобы NetworkManager не перезаписывал каждый раз resolv.conf возвращая обратно DNS по-умолчанию, 
в /etc/NetworkManager/NetworkManager.conf добавляем в [main]:
dns=none
rc-manager=unmanaged
- Перезапускаем:
sudo systemctl restart NetworkManager
- Удаляем resolv.conf и создаем заново:
sudo rm /etc/resolv.conf
sudo touch /etc/resolv.conf
- Пишем туда:
nameserver 127.0.0.1
options edns0
- Запускаем dnscrypt-proxy и включаем автоматический запуск при загрузке:
sudo systemctl start dnscrypt-proxy.service
sudo systemctl enable dnscrypt-proxy.service
- Проверяем в https://dnsleaktest.com, что сервера стоят отличные от серверов вашего провайдера.
- Скачиваем zapret:
git clone --depth 1 https://github.com/bol-van/zapret
- Переходим в папку zapret и выполняем:
sh ./install_bin.sh
- Отключаем все средства блокировки, типа VPN, запускаем blockcheck.sh, чтобы понять каким методом обхода воспользоваться:
sudo sh ./blockcheck.sh
- Вводим через пробел адреса сайтов на которых будем тестировать блокировку. Например, "rutracker.org xvideos.com".
- На все вопросы отвечаем по-умолчанию.
-Далее скрипт будет подбирать варианты обходы блокировок и показывать рабочие. Например:
!!!!! curl_test_https_tls12: working strategy found for ipv4 rutracker.org : tpws --split-pos=1 !!!!!
В данном случае, нужно запустить zapret в режиме tpws c опцией --split-pos=1. Опций можно добавлять несколько.
- Можно прекратить выполнение скрипта и воспользоваться этим методов обхода, либо дождаться и выявить все возможные варианты.
- Выполняем автоматическую установку:
sudo ./install_easy.sh
- Отвечаем по-умолчанию, кроме вопроса, где надо выбрать tpws или nfqws. Выбираем нужный режим на котором работает обход блокировки. 
Если надо, соглашаемся на редактирование опций. Откроется редактор, где прописываем найденный способ опхода. 
Например, "--hostspell=HOST --split-http-req=method --split-pos=1".
- Программа будет скопирована в /opt/zapret/, запустятся все необходимые службы.
- Проверяем в браузере работоспособность обхода. Некоторые заблокированные сайты с данной программой возможно работать не будут, например https://tutanota.com/.
- Файл конфигурации будет лежать по пути /opt/zapret/config.
- При отсутствии работоспособности проверяем работу dnscrypt-proxy и zapret:
systemctl status dnscrypt-proxy
systemctl status zapret

Дополнительная информация: <br>
https://github.com/bol-van/zapret <br>
https://github.com/bol-van/zapret/blob/master/docs/quick_start.txt
