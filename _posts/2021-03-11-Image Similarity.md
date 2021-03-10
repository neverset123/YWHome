---
layout:     post
title:      image similarity
subtitle:   
date:       2021-03-11
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---

use L2-Norm or Euclidean Distance of image histograms to decide image similarity

    from PIL import Image
    from collections import Counter
    import numpy as np
    reference_image_1 = Image.open('Reference_image1.jpg')
    reference_image_arr = np.asarray(reference_image_1)
    flat_array_1 = array1.flatten()
    print(np.shape(flat_array_1))
    #generate count histogram
    RH1 = Counter(flat_array_1)
    H1 = []
    for i in range(256):
        if i in RH1.keys():
            H1.append(RH1[i])
        else:
            H1.append(0)

    # euclidean distance function
    def L2Norm(H1,H2):
        distance =0
        for i in range(len(H1)):
            distance += np.square(H1[i]-H2[i])
        return np.sqrt(distance)
    
    #evaluation
    dist_test_ref_1 = L2Norm(H1,test_H)
    print("The distance between Reference_Image_1 and Test Image is : {}".format(dist_test_ref_1))
    dist_test_ref_2 = L2Norm(H2,test_H)
    print("The distance between Reference_Image_2 and Test Image is : {}".format(dist_test_ref_2))