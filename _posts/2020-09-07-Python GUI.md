---
layout:     post
title:      python GUI
subtitle:   
date:       2020-09-07
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

DearPyGui is supported in python3.8+
## example

    from dearpygui.dearpygui import *
    add_text("Hello world")
    add_button("Save", callback="save_callback")
    add_input_text("string")
    add_slider_float("float")
    def save_callback(sender, data):
        print("Save Clicked")
    
    start_dearpygui()

## layout
  
    from dearpygui.dearpygui import *
    add_button("Button1")
    add_button("Button2")
    
    add_same_line()
    add_button("Button3")
    
    add_button("Button4")
    add_button("Button5")
    add_same_line()
    add_group("Group1")
    add_button("Button6")
    add_button("Button7")
    end_group()
    
    start_dearpygui()
 
 ## combination with other GUI framework
DearPyGui can be combined with tkinter

    from dearpygui.dearpygui import *
    from tkinter import Tk, Label, Button
    
    # tkinter
    root = Tk()
    root.title("A simple GUI")
    root.button = Button(root, text="Press me")
    root.button.pack()
    
    # DearPyGui
    add_slider_float("Slider")
    add_button("Get Value", callback="button_callback")
    
    setup_dearpygui()
    whileTrue:
        render_dearpygui_frame()
        root.update()
    
    cleanup_dearpygui()
