FROM python:3.9

WORKDIR /code


COPY models--openai--whisper-small /code/models--openai--whisper-small
COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY ./main.py /code/main.py

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
