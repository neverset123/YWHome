---
layout:     post
title:      speech to text
subtitle:   
date:       2021-03-04
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - nlp
---

## Wav2Vec
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20210304001202.png)

    # Installing Transformer
    !pip install -q transformers
    # Import necessary library
    # For managing audio file
    import librosa
    #Importing Pytorch
    import torch
    #Importing Wav2Vec
    from transformers import Wav2Vec2ForCTC, Wav2Vec2Tokenizer
    # Reading taken audio clip
    #Wav2Vec model is pre-trained on 16 kHz frequency, a resampling to a 16 kHz is needed with https://audio.online-convert.com/convert-to-wav
    import IPython.display as display
    display.Audio("taken_clip.wav", autoplay=True)
    # Loading the audio file
    audio, rate = librosa.load("taken_clip.wav", sr = 16000)
    # Importing Wav2Vec pretrained model
    tokenizer = Wav2Vec2Tokenizer.from_pretrained("facebook/wav2vec2-base-960h")
    model = Wav2Vec2ForCTC.from_pretrained("facebook/wav2vec2-base-960h")
    # Taking an input value and passing the audio (array) into tokenizer
    input_values = tokenizer(audio, return_tensors = "pt").input_values
    # Storing logits (non-normalized prediction values)
    logits = model(input_values).logits
    # Storing predicted ids
    prediction = torch.argmax(logits, dim = -1)
    # Passing the prediction to the tokenzer decode to get the transcription
    transcription = tokenizer.batch_decode(prediction)[0]
    # Printing the transcription
    print(transcription)