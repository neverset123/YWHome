---
layout:     post
title:      Notificaiton
subtitle:   
date:       2020-10-04
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - Python
---


there are two ways to get notified when a job a done
## beep

    import os 

    def make_noise():
        '''Make noise after finishing executing a code'''
        duration = 1  # seconds
        freq = 440  # Hz
        os.system('play -nq -t alsa synth {} sine {}'.format(duration, freq))

## email or message

    #pip install knockknock
    from knockknock import email_sender
    @email_sender(recipient_emails=["youremail@gmail.com"], sender_email="anotheremail@gmail.com")
    def main():
        even_arr = []
        for i in range(10000):
            if i%2==0:
                even_arr.append(i)
