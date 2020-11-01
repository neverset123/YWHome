---
layout:     post
title:      knowledge graph
subtitle:   
date:       2020-09-13
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - NLP
---

knowledge graph is a manner to store data in a structured way.

## implementation

    import spacy
    from spacy.lang.en import English
    import networkx as nx
    import matplotlib.pyplot as plt

    def getSentences(text):
        nlp = English()
        nlp.add_pipe(nlp.create_pipe('sentencizer'))
        document = nlp(text)
        return [sent.string.strip() for sent in document.sents]
    def printToken(token):
        print(token.text, "->", token.dep_)
    def appendChunk(original, chunk):
        return original + ' ' + chunk
    def isRelationCandidate(token):
        deps = ["ROOT", "adj", "attr", "agent", "amod"]
        return any(subs in token.dep_ for subs in deps)
    def isConstructionCandidate(token):
        deps = ["compound", "prep", "conj", "mod"]
        return any(subs in token.dep_ for subs in deps)
    def processSubjectObjectPairs(tokens):
        subject = ''
        object = ''
        relation = ''
        subjectConstruction = ''
        objectConstruction = ''
        for token in tokens:
            printToken(token)
            if "punct" in token.dep_:
                continue
            if isRelationCandidate(token):
                relation = appendChunk(relation, token.lemma_)
            if isConstructionCandidate(token):
                if subjectConstruction:
                    subjectConstruction = appendChunk(subjectConstruction, token.text)
                if objectConstruction:
                    objectConstruction = appendChunk(objectConstruction, token.text)
            if "subj" in token.dep_:
                subject = appendChunk(subject, token.text)
                subject = appendChunk(subjectConstruction, subject)
                subjectConstruction = ''
            if "obj" in token.dep_:
                object = appendChunk(object, token.text)
                object = appendChunk(objectConstruction, object)
                objectConstruction = ''
        print (subject.strip(), ",", relation.strip(), ",", object.strip())
        return (subject.strip(), relation.strip(), object.strip())
    def processSentence(sentence):
        tokens = nlp_model(sentence)
        return processSubjectObjectPairs(tokens)
    def printGraph(triples):
        G = nx.Graph()
        for triple in triples:
            G.add_node(triple[0])
            G.add_node(triple[1])
            G.add_node(triple[2])
            G.add_edge(triple[0], triple[1])
            G.add_edge(triple[1], triple[2])
        pos = nx.spring_layout(G)
        plt.figure(figsize=(12, 8))
        nx.draw(G, pos, edge_color='black', width=1, linewidths=1,
                node_size=500, node_color='skyblue', alpha=0.9,
                labels={node: node for node in G.nodes()})
        plt.axis('off')
        plt.show()
    
    if __name__ == "__main__":
        text = "Bhubaneswar is the capital and largest city of the Indian state of Odisha. The city is bounded by the Daya River " \
                "to the south and the Kuakhai River to the east; the Chandaka Wildlife Sanctuary "\
                "and Nandankanan Zoo lie in the western and northern parts of Bhubaneswar." \
                "Bhubaneswar is categorised as a Tier-2 city." \
                "Bhubaneswar and Cuttack are often referred to as the 'twin cities of Odisha'. " \
                "The city has a population of 1163000."        
        sentences = getSentences(text)
        nlp_model = spacy.load('en_core_web_sm')
        triples = []
        print (text)
        for sentence in sentences:
            triples.append(processSentence(sentence))
        printGraph(triples)