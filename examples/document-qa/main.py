from transformers import pipeline
import json
from fastapi import FastAPI, File, HTTPException
import tempfile
import base64

from PIL import Image

app = FastAPI()

nlp = pipeline(
    "document-question-answering",
    model="./models--impira--layoutlm-document-qa/snapshots/beed3c4d02d86017ebca5bd0fdf210046b907aa6",
)

@app.put("/run/")
async def infer(input: bytes = File()):
    try:
        json_input = json.loads(input.decode("utf-8"))
        img_data = json_input["image"].encode()
        content = base64.b64decode(img_data)
        with tempfile.NamedTemporaryFile() as fp:
            fp.write(content)
            result = nlp(
                fp.name,
                json_input["question"]
            )
        return {"results": result}
    except:
        raise HTTPException(status_code=400, detail="Your request was malformed")