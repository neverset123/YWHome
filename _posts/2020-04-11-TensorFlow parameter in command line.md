---
layout:     post
title:      tensorflow parameter in command line
subtitle:   
date:       2020-04-11
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

tf.app.flags support arguments pass-in during call python in command line

## purpose
* default global variables definition
* taking in arguments

## tf.app.flags(name, default_value, description)

    tf.app.flags.DEFINE_string('str_name', 'def_v_1',"descrip1")
    tf.app.flags.DEFINE_integer('int_name', 10,"descript2")
    tf.app.flags.DEFINE_boolean('bool_name', False, "descript3")
    tf.app.flags.DEFINE_float("learning_rate", 0.001, "learning rate")
    FLAGS = tf.app.flags.FLAGS
    def main(_): # the _ has to be there for default args 
    print(FLAGS.str_name)
    print(FLAGS.int_name)
    print(FLAGS.bool_name)

if __name__ == '__main__':
    tf.app.run()


