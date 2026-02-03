# Infra

## Run

1. Clone the repository with submodules:
   ```bash
   git clone --recurse-submodules https://github.com/AnonymousUniverityReviews/infra.git
   ```
    
2. Navigate to the repository directory:
    ```bash
    cd infra
    ```
3. Start the system:
    ```bash
    docker-compose up --build
    ```

4. Access to services:
    Фронт: http://localhost:3000
    Бек: http://localhost:5000
    База: PostgreSQL на порту 5432

## Submodules

1. If you cloned the repository without --recurse-submodules, run:
   ```bash
   git submodule update --init --recursive
   ```
2. To update all submodules to their latest commits:
   ```bash
   git submodule update --remote --merge
   ```
