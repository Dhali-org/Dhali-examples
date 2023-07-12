import requests
from bs4 import BeautifulSoup
from fastapi import FastAPI, File
import nltk

app = FastAPI()

@app.put("/run/")
async def infer(input: bytes = File()):

   url = input.decode("utf-8").strip()

   response = requests.get(url)
   soup = BeautifulSoup(response.text, 'html.parser')

   for script in soup(["script", "style"]):
      script.extract()

   text = soup.get_text()

   #If `input` is a text string:
   tokens = nltk.word_tokenize(text)
   pos = nltk.pos_tag(tokens)

   results = []
   for entry in pos:
     results += [entry[0], entry[1]]

   results = [list(entry) for entry in pos]

   return {"results": results}
