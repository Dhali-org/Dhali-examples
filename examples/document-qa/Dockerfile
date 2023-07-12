FROM python:3.9

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt
RUN apt update
RUN apt install -y python3-pil tesseract-ocr libtesseract-dev tesseract-ocr-eng tesseract-ocr-script-latn
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY models--impira--layoutlm-document-qa /code/models--impira--layoutlm-document-qa

COPY ./main.py /code/main.py

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
