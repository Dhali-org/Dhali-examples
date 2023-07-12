import soundfile as sf
import numpy as np
import json

with open("output.json") as f:  
    # returns JSON object as 
    # a dictionary
    data = json.load(f)
    speech = np.array(data['results'])
    sf.write("speech.wav", speech, samplerate=16000)