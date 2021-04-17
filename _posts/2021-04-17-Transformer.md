---
layout:     post
title:      transformer
subtitle:   
date:       2021-04-17
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - NLP
---

## tips
### lightseq
lightseq is make inferencing process faster

#### installation

`pip3 install lightseq`

#### usage
lightseq can only receive the model file defined by the Protocol Buffer protocol. hf_bart_export.py will convert the huggingface pre-trained bart model to Protocol Buffer format for transformer_pb2.py.
1) convert model to Protocol Buffer format
`python3 hf_bart_export.py`
2) inference script

    ```import lightseq
    from transformers import BartTokenizer

    tokenizer = BartTokenizer.from_pretrained("facebook/bart-base")
    model = lightseq.Transformer("lightseq_bart_base.pb", 128)

    sentences = ["I love that girl, but <mask> does not <mask> me."]
    inputs = tokenizer(sentences, return_tensors="pt", padding=True)
    generated_ids = model.infer(inputs["input_ids"])
    generated_ids = [ids[0] for ids in generated_ids[0]]
    res = tokenizer.batch_decode(generated_ids, skip_special_tokens=True)
    print(res)```
