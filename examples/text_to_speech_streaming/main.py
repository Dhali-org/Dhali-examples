from transformers import SpeechT5Processor, SpeechT5ForTextToSpeech, SpeechT5HifiGan
from datasets import load_dataset
import torch
from fastapi import FastAPI, File
import json
import soundfile as sf
from fastapi.responses import StreamingResponse
import io

processor = SpeechT5Processor.from_pretrained("microsoft/speecht5_tts", cache_dir='')
model = SpeechT5ForTextToSpeech.from_pretrained("microsoft/speecht5_tts", cache_dir='')
vocoder = SpeechT5HifiGan.from_pretrained("microsoft/speecht5_hifigan", cache_dir='')
# load xvector containing speaker's voice characteristics from a dataset
embeddings_dataset = load_dataset("Matthijs/cmu-arctic-xvectors", split="validation", cache_dir=".")
app = FastAPI()

@app.put("/run/")
async def infer(input: bytes = File()):
    json_input = json.loads(input.decode("utf-8"))
    speaker_embeddings = torch.tensor(embeddings_dataset[json_input["accent"]]["xvector"]).unsqueeze(0)
    inputs = processor(text=json_input["text"], return_tensors="pt")
    speech = model.generate_speech(inputs["input_ids"], speaker_embeddings, vocoder=vocoder)

    # Create an in-memory BytesIO object
    buffer = io.BytesIO()
    sf.write(buffer, speech.numpy().squeeze(), 22050, format="wav")

    # "Seek" to the start of the BytesIO object so it can be read from the beginning
    buffer.seek(0)

    # Create a StreamingResponse that streams the wav file
    response = StreamingResponse(buffer, media_type="audio/wav")

    return response
