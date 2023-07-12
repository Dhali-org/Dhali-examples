# speech-to-text

This asset converts `.wav` audio english speech files into text. Results may not return if your `.wav` file is too big.

## Prepare input

This asset accepts `.wav` inputs. For maximum asset efficiency, be sure to provide this asset with 16KHz `.wav` file. Otherwise, it will be converted to a 16KHz file by the asset. 

## Process output

This model outputs a dictionary of the form
```
{"result":"SOME CONVERTED TEXT FROM AN AUDIO FILE"}
```