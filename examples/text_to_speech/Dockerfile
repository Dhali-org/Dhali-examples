FROM python:3.9

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY downloads /code/downloads
COPY Matthijs___cmu-arctic-xvectors /code/Matthijs___cmu-arctic-xvectors
COPY models--microsoft--speecht5_tts /code/models--microsoft--speecht5_tts
COPY ._Matthijs___cmu-arctic-xvectors_default_0.0.1_a62fea1f9415e240301ea0042ffad2a3aadf4d1caa7f9a8d9512d631723e781f.lock /code/._Matthijs___cmu-arctic-xvectors_default_0.0.1_a62fea1f9415e240301ea0042ffad2a3aadf4d1caa7f9a8d9512d631723e781f.lock
COPY ./config.json /code/config.json

COPY ./main.py /code/main.py

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
