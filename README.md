<p align="center">
  <img src="./images/dhali-logo.png" />
</p>


* [Dhali](https://dhali.io/#/) is a Web 3.0 open marketplace for creators and consumers of AI. To interact with the marketplace users simply stream blockchain enabled micropayments for what they need, when they need it. No logins or subscriptions are required.
* [Dhali-examples](https://github.com/Dhali-org/Dhali-examples) provides a collection of example assets that can be uploaded to Dhali. In some cases, it also provides example applications for consuming the services of the assets.


# Examples

These Dhali assets can be deployed and monetized through Dhali. Each asset is built ontop of [this](https://github.com/Dhali-org/Dhali-asset-template) template. To understand how to build and deploy these assets, see [here](https://dhali.io/docs/#/?id=creating-dhali-assets)

## image_net_classifier

This asset provides basic image-net classification (computer vision) functionality on-demand.
* [Deployment instructions](./examples/image_net_classifier/asset). Once deployed, this asset should be visible in the Dhali marketplace.
* [Usage instructions](./examples/image_net_classifier/consumer_application).


## document-qa

This [asset](./examples/document-qa) uses the [layoutlm-document-qa](https://huggingface.co/impira/layoutlm-document-qa) model from Huggingface. It allows users to ask natural language questions against documents.

## text_to_speech


This [asset](./examples/text_to_speech) uses the [speecht5_tts](https://huggingface.co/microsoft/speecht5_tts) model from Huggingface. It allows users to convert text into speech.


## webminer


This [asset](./examples/webminer)  performs parts-of-speech tagging and provides outputs in NLTK format.


## whisper-small


 This [asset](./examples/whisper-small) uses the [whisper-small](https://huggingface.co/openai/whisper-small) model from Huggingface. It allows users to convert natural language into text.
