import tensorflow as tf
import numpy as np
from fastapi import FastAPI, File

from PIL import Image
import io
from imagenet_labels import labels

app = FastAPI()
# https://tfhub.dev/google/efficientnet/b3/classification/1
model = tf.saved_model.load("efficient_net", tags=[])

@app.put("/run/")
async def infer(input: bytes = File()):
    infer = model.signatures["image_classification"]
    img = Image.open(io.BytesIO(input))
    img = img.resize([300, 300])
    x = tf.keras.preprocessing.image.img_to_array(img)
    x = x[tf.newaxis, ...] / 255.0
    labeling = infer(tf.constant(x))
    predictions = tf.nn.softmax(labeling["default"][0])

    prediction = np.argsort(predictions)
    return {
        "results": [
            {
                "label": f"{labels[prediction[-1]]}",
                "probability": f"{predictions[prediction[-1]]}",
            },
            {
                "label": f"{labels[prediction[-2]]}",
                "probability": f"{predictions[prediction[-2]]}",
            },
            {
                "label": f"{labels[prediction[-3]]}",
                "probability": f"{predictions[prediction[-3]]}",
            },
            {
                "label": f"{labels[prediction[-4]]}",
                "probability": f"{predictions[prediction[-4]]}",
            },
            {
                "label": f"{labels[prediction[-5]]}",
                "probability": f"{predictions[prediction[-5]]}",
            },
        ]
    }
