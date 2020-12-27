---
layout:     post
title:      tensorflow serving
subtitle:   
date:       2020-12-27
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - tensorflow
---

## define servable
### TensorFlow function as servable

    class Adder(tf.Module):
        @tf.function(input_signature=[tf.TensorSpec(shape=[None,3], dtype=tf.float32, name="x")])
        def sum_two(self, x):
            return x + 2
    class Randomizer(tf.Module):
        @tf.function
        def fun_runif(self, N):
            return tf.random.uniform(shape=(N,))
    
    # For the first function
    myfun = Adder()
    tf.saved_model.save(myfun, "tmp/sum_two/1")
    
    # For the second function
    myfun2 = Randomizer()
    tf.saved_model.save(myfun2, "tmp/fun_runif/1")

### Keras model as servable

    class CustomMobileNet_string(tf.keras.Model):
        model_handler = "https://tfhub.dev/google/imagenet/mobilenet_v2_035_224/classification/4"
        
        def __init__(self):
            super(CustomMobileNet_string, self).__init__()
            self.model = hub.load(self.__class__.model_handler)
            self.labels = None
            
        # Design you API with 'tf.function' decorator
        @tf.function(input_signature=[tf.TensorSpec(shape=None, dtype=tf.string)])
        def call(self, input_img):
            def _preprocess(img_file):
                img_bytes = tf.reshape(img_file, [])
                img = tf.io.decode_jpeg(img_bytes, channels=3)
                img = tf.image.convert_image_dtype(img, tf.float32)
                return tf.image.resize(img, (224, 224))
    
            labels = tf.io.read_file(self.labels)
            labels = tf.strings.split(labels, sep='\n')
            img = _preprocess(input_img)[tf.newaxis,:]
            logits = self.model(img)
            get_class = lambda x: labels[tf.argmax(x)]
            class_text = tf.map_fn(get_class, logits, tf.string)
            return class_text # index of the class
    
    model_string = CustomMobileNet_string()
    # Save the image labels as an asset, saved in 'Assets' folder
    model_string.labels = tf.saved_model.Asset("data/labels/ImageNetLabels.txt")
    tf.saved_model.save(model_string, "tmp/mobilenet_v2_test/1/")

## deploying servable
### tensorflow model
    # Download the TensorFlow Serving Docker image and repo
    docker pull tensorflow/serving
    
    git clone https://github.com/tensorflow/serving
    # Location of demo models
    TESTDATA="$(pwd)/serving/tensorflow_serving/servables/tensorflow/testdata"
    
    # Start TensorFlow Serving container and open the REST API port
    docker run -t --rm -p 8501:8501 \
        -v "$TESTDATA/saved_model_half_plus_two_cpu:/models/half_plus_two" \
        -e MODEL_NAME=half_plus_two \
        tensorflow/serving &
    
    # Query the model using the predict API
    curl -d '{"instances": [1.0, 2.0, 5.0]}' \
        -X POST http://localhost:8501/v1/models/half_plus_two:predict
    
    # Returns => { "predictions": [2.5, 3.0, 4.5] }

### keras model

    docker run -t --rm -p 8501:8501 -v "$(pwd)/mobilenet_v2_test:/models/mobilenet_v2_test" -e MODEL_NAME=mobilenet_v2_test tensorflow/serving &