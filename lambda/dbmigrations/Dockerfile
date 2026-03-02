FROM public.ecr.aws/lambda/python:3.13

# Копіюємо файл залежностей
COPY requirements.txt ${LAMBDA_TASK_ROOT}

# Встановлюємо залежності безпосередньо (без системних пакетів)
RUN pip3 install --no-cache-dir -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

# Копіюємо код функції
COPY main.py ${LAMBDA_TASK_ROOT}

# Вказуємо точку входу
CMD ["main.handler"]