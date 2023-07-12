# website data miner

Input a web page, and it will return requested information.

Current features:

* A parts-of-speech tagger, that outputs in NLTK format.

More coming soon!

## Example:
Any valid url, needs http or https:
```
"https://example.com"
```

Output:
```
{'results': [['Example', 'NNP'], ['Domain', 'NNP'], ['Example', 'NNP'], ['Domain', 'NNP'], ['This', 'DT'], ['domain', 'NN'], ['is', 'VBZ'], ['for', 'IN'], ['use', 'NN'], ['in', 'IN'], ['illustrative', 'JJ'], ['examples', 'NNS'], ['in', 'IN'], ['documents', 'NNS'], ['.', '.'], ['You', 'PRP'], ['may', 'MD'], ['use', 'VB'], ['this', 'DT'], ['domain', 'NN'], ['in', 'IN'], ['literature', 'NN'], ['without', 'IN'], ['prior', 'JJ'], ['coordination', 'NN'], ['or', 'CC'], ['asking', 'VBG'], ['for', 'IN'], ['permission', 'NN'], ['.', '.'], ['More', 'JJR'], ['information', 'NN'], ['...', ':']]}

```

