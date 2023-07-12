---
language: en
license: mit
---

# Using the asset

## Manually

This asset accepts json text files of the form
```json
{
    "image": <base64 encoded image>,
    "question": "Is this a sample question?"
}
```
To manually prepare the json on a linux system, the following command can be used:
```json
echo "{\"image\": \"$(base64 -w 0 <path to image>)\", \"question\":\"A question?\"}" > /tmp/input.json
```
This will give you a `json` file which can be manually uploaded to the asset.

# Model information

This is a fine-tuned version of the multi-modal [LayoutLM](https://aka.ms/layoutlm) model for the task of question answering on documents. It has been fine-tuned using both the [SQuAD2.0](https://huggingface.co/datasets/squad_v2) and [DocVQA](https://www.docvqa.org/) datasets.
