import io
from fastapi import FastAPI, File, HTTPException
import numpy as np
from transformers import AutomaticSpeechRecognitionPipeline, WhisperProcessor, WhisperForConditionalGeneration
import wave
from scipy import signal
from transformers import pipeline
import torch

app = FastAPI()

processor = WhisperProcessor.from_pretrained("openai/whisper-small", cache_dir='')
alignment_heads = [[5, 3], [5, 9], [8, 0], [8, 4], [8, 7], [8, 8], [9, 0], [9, 7], [9, 9], [10, 5]]

model = WhisperForConditionalGeneration.from_pretrained("openai/whisper-small", cache_dir='')
pipe = AutomaticSpeechRecognitionPipeline(
    model=model,
    tokenizer=processor.tokenizer,
    feature_extractor=processor.feature_extractor,
)
pipe.model.generation_config.alignment_heads = alignment_heads

desired_sample_rate = 16000

@app.put("/run/")
async def infer(input: bytes = File()):

    try:

        # Create an in-memory file-like object from the audio bytes
        audio_file = io.BytesIO(input)
        
        # Open the in-memory file-like object as a WAV file
        wav_file = wave.open(audio_file, 'rb')
        # Extract the WAV object
        audio_frames = wav_file.readframes(wav_file.getnframes())
        int_numpy_input = np.frombuffer(audio_frames, dtype=np.int16)
        max_int_value = np.iinfo(int_numpy_input.dtype).max
        numpy_input = int_numpy_input.astype(np.float32) / max_int_value
        sample_rate = wav_file.getframerate()
        if wav_file.getframerate() != desired_sample_rate:
            numpy_input = signal.resample(numpy_input, int(len(numpy_input) * (desired_sample_rate / sample_rate)))

        output = pipe(numpy_input, chunk_length_s=30, stride_length_s=[4, 2], return_timestamps="word")


        if sample_rate != desired_sample_rate:
            return {"result": output, 
                    "info": f"Ensure you sample at 16kHz for maximum efficiency. Your current sample rate is {sample_rate}"}
        else:
            return {"result": output}
    
    except Exception as e:
        raise HTTPException(422, f"Your input could not be parsed: {e}")
