FROM python:3.9

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./imagenet_labels.py /code/imagenet_labels.py
COPY efficient_net /code/efficient_net
COPY ./main.py /code/main.py


CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
