---
layout:     post
title:      ms word table
subtitle:   
date:       2020-12-29
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

python-docx is the library needed for python to interact with ms word

## installation
pip install python-docx

## usage

        def describe_text(text):
        import re, string
        
        description = dict()
        
        # remove punctuation marks
        text_wo_punctuation_marks = re.sub(f'[%s]' % re.escape(string.punctuation), '', text)
        
        # tokens of the text without punctuation marks
        tokens_of_text_wo_punctuation_marks = text_wo_punctuation_marks.split(' ') 
        
        # list of sentences
        pattern = re.compile(r'([A-Z][^\.!?]*[\.!?])', re.M)
        list_of_sentences = re.findall(pattern, text)
        
        # sentence character and word counts
        list_of_sentence_character_count = [len(sentence) for sentence in list_of_sentences]
        list_of_sentence_words_counts = [len(sentence.split(' ')) for sentence in list_of_sentences]
        
        description['Number of characters'] = len(text) 
        description['Number of words'] = len(tokens_of_text_wo_punctuation_marks)
        description['Number of unique words'] = len(set(tokens_of_text_wo_punctuation_marks)) 
        description['Number of sentences'] = len(list_of_sentences)
        description['Number of new lines'] = len([char for char in text if char == '\n'])
        description['Number of punctuatino marks'] = len([char for char in text if char in string.punctuation])
        description['Average words per sentence'] = round(len(tokens_of_text_wo_punctuation_marks)/len(list_of_sentences), 2)
        description['Average word length'] = round(sum([len(token) for token in tokens_of_text_wo_punctuation_marks])/len(tokens_of_text_wo_punctuation_marks), 2)
        description['Maximum characters in a sentence'] = max(list_of_sentence_character_count)
        description['Minimum characters in a sentence'] = min(list_of_sentence_character_count)
        description['Maximum words in a sentence'] = max(list_of_sentence_words_counts)
        description['Minimum words in a sentence'] = min(list_of_sentence_words_counts)
        description['Contains numbers'] = any(char.isdigit() for char in text)
        description['Contains unicode characters'] = any([ord(char) > 255] for char in text)
        description['Contains interrogative sentences'] = '?' in text
        description['Contains exclamatory sentences'] = '!' in text
        
        return description

        # Test
        text = """Even at a school like CSM, the knitwear avenue is still considered a ‘niche’ pursuit. “I still get a lot of patronising remarks about knitting, mostly from men, who say things like ‘Oh so you just knit in a circle?’ The reality is that I’m operating intense machinery on a day-to-day basis. And even if I was knitting in a circle, what’s wrong with that?”"""
        describe_text(text)

        # {
        #     'Number of characters': 355,
        #     'Number of words': 65,
        #     'Number of unique words': 55,
        #     'Number of sentences': 4,
        #     'Number of new lines': 0,
        #     'Number of punctuatino marks': 10,
        #     'Average words per sentence': 16.25,
        #     'Average word length': 4.32,
        #     'Maximum characters in a sentence': 127,
        #     'Minimum characters in a sentence': 63,
        #     'Maximum words in a sentence': 25,
        #     'Minimum words in a sentence': 12,
        #     'Contains numbers': False,
        #     'Contains unicode characters': True,
        #     'Contains interrogative sentences': True,
        #     'Contains exclamatory sentences': False
        # }

        #main.py
        from docx import Document
        from docx.shared import Cm, Pt


        article_1 = """Bayern Munich came out on top in a thrilling German Cup final, beating Bayer Leverkusen 4-2 to secure its 20th title and remain on course for an historic treble.
        David Alaba's stunning free kick and Serge Gnabry's clinical finish gave Bayern a commanding lead heading into half time and Hans-Dieter Flick's side seemingly already had one hand on the trophy.
        However, Leverkusen responded well early in the second half and had a golden opportunity to halve the deficit through substitute Kevin Volland."""

        article_2 = """(CNN)Liverpool got its Premier League title-winning celebrations back on track with a 2-0 win over Aston Villa, just days after being on the receiving end of a record-equaling defeat.
        Many had suggested Jurgen Klopp's side was suffering from something of a hangover during Thursday's 4-0 demolition at the hands of Manchester City -- the joint-heaviest defeat by a team already crowned Premier League champion -- but Liverpool recovered in time to put relegation-threatened Aston Villa to the sword.
        It wasn't all plain sailing at Anfield on Sunday as Villa wasted several good opportunities to take the lead, before Sadio Mane eventually broke the deadlock after 71 minutes. Villa, who gave the host a guard of honor before the game, had further chances to level the scores, but Liverpool youngster Curtis Jones wrapped up the victory in the dying moments with his first Premier League goal."""

        list_of_articles = [article_1, article_2]

        word_document = Document()
        document_name = 'news-article-stats'

        for article in list_of_articles:
        # extracting text stats
        text_stats = describe_text(article)
        text_stats['Article'] = article
        text_stats = dict(sorted(text_stats.items()))
        
        # customizing the table
        table = word_document.add_table(0, 0) # we add rows iteratively
        table.style = 'TableGrid'
        first_column_width = 5
        second_column_with = 10
        table.add_column(Cm(first_column_width))
        table.add_column(Cm(second_column_with))
        
        for index, stat_item in enumerate(text_stats.items()):
                table.add_row()
                stat_name, stat_result = stat_item
                row = table.rows[index]
                row.cells[0].text = str(stat_name)
                row.cells[1].text = str(stat_result)
        word_document.add_page_break()

        word_document.save(document_name + '.docx')