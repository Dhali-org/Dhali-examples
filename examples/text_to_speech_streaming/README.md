---
license: mit
tags:
- audio
- text-to-speech
datasets:
- libritts
---

#  Asset consumption

This asset accepts json text files of the form
```json
{
    "accent": 7306,
    "text": "Sample text to be converted from text to speech"
}
```
The accent should be a value between `0` and `7930`, representing one of the `7931` accents available through the [CMU_ARCTIC](http://www.festvox.org/cmu_arctic/) database.

The asset will return `.json` file, with a "result" field containing samples that can be converted to a `.wav` file:
```
import soundfile as sf
import numpy as np
import json

with open("output.json") as f:  
    # returns JSON object as 
    # a dictionary
    data = json.load(f)
    speech = np.array(data['results'])
    sf.write("speech.wav", speech, samplerate=16000)
```

# SpeechT5 (TTS task)

SpeechT5 model fine-tuned for speech synthesis (text-to-speech) on LibriTTS.

This model was introduced in [SpeechT5: Unified-Modal Encoder-Decoder Pre-Training for Spoken Language Processing](https://arxiv.org/abs/2110.07205) by Junyi Ao, Rui Wang, Long Zhou, Chengyi Wang, Shuo Ren, Yu Wu, Shujie Liu, Tom Ko, Qing Li, Yu Zhang, Zhihua Wei, Yao Qian, Jinyu Li, Furu Wei.

SpeechT5 was first released in [this repository](https://github.com/microsoft/SpeechT5/), [original weights](https://huggingface.co/mechanicalsea/speecht5-tts). The license used is [MIT](https://github.com/microsoft/SpeechT5/blob/main/LICENSE).



## Model Description

Motivated by the success of T5 (Text-To-Text Transfer Transformer) in pre-trained natural language processing models, we propose a unified-modal SpeechT5 framework that explores the encoder-decoder pre-training for self-supervised speech/text representation learning. The SpeechT5 framework consists of a shared encoder-decoder network and six modal-specific (speech/text) pre/post-nets. After preprocessing the input speech/text through the pre-nets, the shared encoder-decoder network models the sequence-to-sequence transformation, and then the post-nets generate the output in the speech/text modality based on the output of the decoder.

Leveraging large-scale unlabeled speech and text data, we pre-train SpeechT5 to learn a unified-modal representation, hoping to improve the modeling capability for both speech and text. To align the textual and speech information into this unified semantic space, we propose a cross-modal vector quantization approach that randomly mixes up speech/text states with latent units as the interface between encoder and decoder.

Extensive evaluations show the superiority of the proposed SpeechT5 framework on a wide variety of spoken language processing tasks, including automatic speech recognition, speech synthesis, speech translation, voice conversion, speech enhancement, and speaker identification.

- **Developed by:** Junyi Ao, Rui Wang, Long Zhou, Chengyi Wang, Shuo Ren, Yu Wu, Shujie Liu, Tom Ko, Qing Li, Yu Zhang, Zhihua Wei, Yao Qian, Jinyu Li, Furu Wei.
- **Shared by [optional]:** [Matthijs Hollemans](https://huggingface.co/Matthijs)
- **Model type:** text-to-speech
- **Language(s) (NLP):** [More Information Needed]
- **License:** [MIT](https://github.com/microsoft/SpeechT5/blob/main/LICENSE)
- **Finetuned from model [optional]:** [More Information Needed]


## Model Sources [optional]

<!-- Provide the basic links for the model. -->

- **Repository:** [https://github.com/microsoft/SpeechT5/]
- **Paper:** [https://arxiv.org/pdf/2110.07205.pdf]
- **Blog Post:** [https://huggingface.co/blog/speecht5]
- **Demo:** [https://huggingface.co/spaces/Matthijs/speecht5-tts-demo]


# Citation [optional]

<!-- If there is a paper or blog post introducing the model, the APA and Bibtex information for that should go in this section. -->

**BibTeX:**

```bibtex
@inproceedings{ao-etal-2022-speecht5,
    title = {{S}peech{T}5: Unified-Modal Encoder-Decoder Pre-Training for Spoken Language Processing},
    author = {Ao, Junyi and Wang, Rui and Zhou, Long and Wang, Chengyi and Ren, Shuo and Wu, Yu and Liu, Shujie and Ko, Tom and Li, Qing and Zhang, Yu and Wei, Zhihua and Qian, Yao and Li, Jinyu and Wei, Furu},
    booktitle = {Proceedings of the 60th Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers)},
    month = {May},
    year = {2022},
    pages={5723--5738},
}
```
