FROM public.ecr.aws/lambda/python:3.13

COPY requirements.txt ${LAMBDA_TASK_ROOT}
COPY main.py ${LAMBDA_TASK_ROOT}

RUN yum install -y gcc postgresql-devel

RUN pip3 install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

CMD ["main.handler"]