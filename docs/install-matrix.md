# Матрица установки Codex в Android Termux

| Метод установки | Совместимость с Android | Поддержка Remote Control | Сложность | Рекомендация |
| :--- | :---: | :---: | :---: | :--- |
| **`@mmmbuto/codex-cli-termux`** (Community npm) | 🟢 100% Native ARM64 | 🟢 Полная | Низкая (`npm -g`) | **Основной выбор для Termux** |
| **`@openai/codex` + Linux musl ARM64** | 🟡 Частичная (CLI работает) | 🔴 Ошибка сокета / таймаут | Высокая (ручной layout) | Только для тестов CLI |
| **`proot-distro` (Debian/Ubuntu ARM64)** | 🟢 Полноценный Linux | 🟢 Полная | Средняя (требует proot) | Альтернатива при несовместимости |

## Установка рекомендуемого пакета:

```bash
pkg update && pkg install nodejs-lts -y
npm install -g @mmmbuto/codex-cli-termux@latest
codex --version
```
