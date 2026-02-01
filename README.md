# Infra

## Run

1. Клонувати репозиторій з сабмодулями:
   ```bash
   git clone --recurse-submodules https://github.com/AnonymousUniverityReviews/infra.git
   ```
    
2. Перейти в папку репозиторію:
    ```bash
    cd infra
    ```
3. Запустити систему:
    ```bash
    docker-compose up --build
    ```

4. Доступ до сервісів:
    Фронт: http://localhost:3000
    Бек: http://localhost:5000
    База: PostgreSQL на порту 5432