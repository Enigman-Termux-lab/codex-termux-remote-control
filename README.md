<div align="center">

# 🤖 Codex Remote Control в Termux

### *Управление локальным OpenAI Codex CLI со смартфона через официальное приложение ChatGPT*

[![Termux](https://img.shields.io/badge/Termux-Android-000000?style=for-the-badge&logo=termux&logoColor=white)](https://termux.dev/)
[![Codex](https://img.shields.io/badge/OpenAI-Codex-412991?style=for-the-badge&logo=openai&logoColor=white)](https://openai.com)
[![ChatGPT Mobile](https://img.shields.io/badge/ChatGPT-Mobile%20App-74AA9C?style=for-the-badge&logo=openai&logoColor=white)](https://chatgpt.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

<br/>

**Codex Remote Control в Termux** — готовый инструментарий для запуска и сопряжения [OpenAI Codex CLI](https://github.com/openai/codex) внутри Android Termux с управлением через официальное мобильное приложение ChatGPT Remote Control и виджеты рабочего стола Android.

---

</div>

## 🌟 Как это работает?

1. **В Termux** запускается легковесный `app-server-daemon`, создающий защищенный Unix-сокет.
2. **OpenAI Cloud** связывает вашу Termux-ноду с вашим аккаунтом ChatGPT по безопасному протоколу.
3. **В приложении ChatGPT на телефоне** (раздел Codex → Remote Control) вы можете ставить задачи, запускать тесты и кодить, пока телефон лежит в кармане, а вычисления происходят прямо в Termux на устройстве!
4. **Виджеты на экране**: одним тапом включайте сопряжение и открывайте ChatGPT, либо полностью выключайте все фоновые процессы.

---

## 🚀 Быстрый старт (Установка за 2 минуты)

### 1. Установка нативного Termux-пакета
В нативном Termux ARM64 используется проверенный community-порт с Android-патчами:
```bash
pkg update && pkg install nodejs-lts -y
npm install -g @mmmbuto/codex-cli-termux@latest
codex --version
```

### 2. Авторизация в аккаунте OpenAI
Выполните вход под тем же аккаунтом ChatGPT Plus/Team/Pro:
```bash
codex login --device-auth
```
*(Скопируйте полученный одноразовый код и подтвердите в браузере).*

### 3. Первое сопряжение (Pairing)
Запустите фоновый сервис и запросите pairing-код:
```bash
codex remote-control start --json
codex remote-control pair --json
```
В ответе терминала найдите поле:
```json
"manualPairingCode": "ABCD-1234"
```

### 4. Ввод в приложении ChatGPT
Откройте мобильное приложение **ChatGPT** → меню **Codex** → **Remote Control** → **Добавить устройство вручную** и введите полученный код `ABCD-1234`. Сопряжение завершено! При последующих запусках вводить код заново **не требуется**.

---

## 🔘 Виджеты быстрого доступа (Termux:Widget)

В папке [`scripts/`](scripts/) находятся готовые скрипты для управления Remote Control в один клик:

* **[`scripts/codex-on.sh`](scripts/codex-on.sh)** — запускает Remote-демон, ожидает статус `connected`, автоматически открывает мобильное приложение ChatGPT (`am start --user 0 -n com.openai.chatgpt/.MainActivity`) и отправляет уведомление.
* **[`scripts/codex-off.sh`](scripts/codex-off.sh)** — мягко останавливает удаленное управление (`remote-control stop`), находит и завершает только процессы Codex (не трогая другие задачи Termux) и чистит stale PID.

### Установка виджетов:
```bash
mkdir -p ~/.shortcuts
cp scripts/codex-on.sh scripts/codex-off.sh ~/.shortcuts/
chmod 700 ~/.shortcuts/codex-on.sh ~/.shortcuts/codex-off.sh
```

---

## 🔋 Фоновая работа и батарея Android

Чтобы система Android не выгружала фоновый демон при выключении экрана:
1. В Termux выполните: `termux-wake-lock`.
2. В настройках Android найдите **Termux** → **Батарея** → выберите **«Без ограничений»** (Не оптимизировать).

---

## 📚 Документация

* 📋 [Матрица установки (Native vs Upstream vs PRoot)](docs/install-matrix.md)
* 🔄 [Жизненный цикл фонового сервиса и остановка](docs/remote-lifecycle.md)
* 🧠 [Скилл для AI-агентов](skill/SKILL.md)

---

## 📄 Лицензия

Распространяется под лицензией [MIT](LICENSE). Разработано для открытой экосистемы **[Enigman-Termux-lab](https://github.com/Enigman-Termux-lab)**.
