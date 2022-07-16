---
layout:     post
title:      RCNN
subtitle:   
date:       2020-09-13
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

RCNN stands for Region-based Convolutional Neural Network

## type of RCNN
### Fast RCNN
In R-CNN, feature extraction takes place for each region proposal whereas, in Fast R-CNN, feature extraction takes place only once for an original image.

### Faster RCNN 
Faster R-CNN replaces the exterior region proposal algorithm with a Region Proposal Network (RPN).
it is a two-stage object detector: first it identifies regions of interest, and then passes these regions to a convolutional neural network

### Mask-RCNN
object detection model based on CNN. the project can be cloned on github: 

    git clone https://github.com/matterport/Mask_RCNN.git

#### installation and usage

##### prediction
prediction returned is an object with

    rois: The boxes around each detected object.
    class_ids: The class IDs for the objects.
    scores: The class scores for each object.
    masks: The masks.

    ! python setup.py install
    #config model
    import mrcnn.config
    class SimpleConfig(mrcnn.config.Config):
        #specify number of classes, background must be regarded as an additional class
        NUM_CLASSES = 81
        #batch size is calculated by BATCH_SIZE = IMAGES_PER_GPU * GPU_COUNT
        GPU_COUNT = 1
        IMAGES_PER_GPU = 1
    #create instance
    import mrcnn.model
    model = mrcnn.model.MaskRCNN(mode="inference", 
                                config=SimpleConfig(),
                                model_dir=os.getcwd())
    #check model architecture
    model.keras_model.summary()
    #load weights
    model.load_weights(filepath="mask_rcnn_coco.h5", 
                   by_name=True)
    #read images
    import cv2
    image = cv2.imread("3627527276_6fe8cd9bfe_z.jpg")
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    #Detect Objects
    r = model.detect(images=[image], 
                 verbose=0)
    #Visualize the Results
    import mrcnn.visualize
    CLASS_NAMES = ['BG', 'person', 'bicycle', 'car', 'motorcycle', 'airplane', 'bus', 'train', 'truck', 'boat', 'traffic light', 'fire hydrant', 'stop sign', 'parking meter', 'bench', 'bird', 'cat', 'dog', 'horse', 'sheep', 'cow', 'elephant', 'bear', 'zebra', 'giraffe', 'backpack', 'umbrella', 'handbag', 'tie', 'suitcase', 'frisbee', 'skis', 'snowboard', 'sports ball', 'kite', 'baseball bat', 'baseball glove', 'skateboard', 'surfboard', 'tennis racket', 'bottle', 'wine glass', 'cup', 'fork', 'knife', 'spoon', 'bowl', 'banana', 'apple', 'sandwich', 'orange', 'broccoli', 'carrot', 'hot dog', 'pizza', 'donut', 'cake', 'chair', 'couch', 'potted plant', 'bed', 'dining table', 'toilet', 'tv', 'laptop', 'mouse', 'remote', 'keyboard', 'cell phone', 'microwave', 'oven', 'toaster', 'sink', 'refrigerator', 'book', 'clock', 'vase', 'scissors', 'teddy bear', 'hair drier', 'toothbrush']
    r = r[0]
    mrcnn.visualize.display_instances(image=image, 
                                    boxes=r['rois'], 
                                    masks=r['masks'], 
                                    class_ids=r['class_ids'], 
                                    class_names=CLASS_NAMES, 
                                    scores=r['scores'])

##### training
The mrcnn.utils.Dataset class has a number of useful methods which include:

    add_class(): Adds a new class.
    add_image(): Adds a new image to the dataset.
    image_reference(): The reference (e.g. path or link) by which the image is retrieved.
    prepare(): After adding all the classes and images to the dataset, this method prepares the dataset for use.
    source_image_link(): Returns the path or link of the image.
    load_image(): Reads and return an image.
    load_mask(): Loads the masks for the objects in an image, which must be overriden for customized dataset

to train mask rcnn model for customized dataset, the Dataset class must be overwritten

    import mrcnn.utils
    class KangarooDataset(mrcnn.utils.Dataset):
        
        def load_dataset(self, dataset_dir, is_train=True):
            self.add_class("dataset", 1, "kangaroo")

            images_dir = dataset_dir + '/images/'
            annotations_dir = dataset_dir + '/annots/'

            for filename in os.listdir(images_dir):
                image_id = filename[:-4]

                if image_id in ['00090']:
                    continue

                if is_train and int(image_id) >= 150:
                    continue

                if not is_train and int(image_id) < 150:
                    continue

                img_path = images_dir + filename
                ann_path = annotations_dir + image_id + '.xml'

                self.add_image('dataset', image_id=image_id, path=img_path, annotation=ann_path)

        def extract_boxes(self, filename):
            tree = xml.etree.ElementTree.parse(filename)

            root = tree.getroot()

            boxes = list()
            for box in root.findall('.//bndbox'):
                xmin = int(box.find('xmin').text)
                ymin = int(box.find('ymin').text)
                xmax = int(box.find('xmax').text)
                ymax = int(box.find('ymax').text)
                coors = [xmin, ymin, xmax, ymax]
                boxes.append(coors)

            width = int(root.find('.//size/width').text)
            height = int(root.find('.//size/height').text)
            return boxes, width, height

        def load_mask(self, image_id):
            info = self.image_info[image_id]
            path = info['annotation']
            boxes, w, h = self.extract_boxes(path)
            masks = zeros([h, w, len(boxes)], dtype='uint8')

            class_ids = list()
            for i in range(len(boxes)):
                box = boxes[i]
                row_s, row_e = box[1], box[3]
                col_s, col_e = box[0], box[2]
                masks[row_s:row_e, col_s:col_e, i] = 1
                class_ids.append(self.class_names.index('kangaroo'))
            return masks, asarray(class_ids, dtype='int32')
    
    #load data
    train_set = KangarooDataset()
    train_set.load_dataset(dataset_dir='D:\kangaroo', is_train=True)
    train_set.prepare()
    valid_dataset = KangarooDataset()
    valid_dataset.load_dataset(dataset_dir='D:\kangaroo', is_train=False)
    valid_dataset.prepare()
    #config model
    import mrcnn.config
    class KangarooConfig(mrcnn.config.Config):
        NAME = "kangaroo_cfg"
        GPU_COUNT = 1
        IMAGES_PER_GPU = 1
        NUM_CLASSES = 2
        STEPS_PER_EPOCH = 131
    #train model
    import mrcnn.model
    model = mrcnn.model.MaskRCNN(mode='training', 
                                model_dir='./', 
                                config=KangarooConfig())
    model.load_weights(filepath='mask_rcnn_coco.h5', 
                   by_name=True, 
                   exclude=["mrcnn_class_logits", "mrcnn_bbox_fc",  "mrcnn_bbox", "mrcnn_mask"])
    model.train(train_dataset=train_set, 
            val_dataset=valid_dataset, 
            learning_rate=KangarooConfig().LEARNING_RATE, 
            epochs=10, 
            layers='heads')
    model_path = 'Kangaroo_mask_rcnn.h5'
    model.keras_model.save_weights(model_path)

## library
### Detectron 2
it is an open-source library for object detection and segmentation created by facebook. it implemented common RCNN algorithms(Faster R CNN, Mask R CNN, and RetinaNet) for tasks: 

    Object Detection
    Instance Segmentation
    Keypoint Detection
    Panoptic Segmentation

#### installation

    # install dependencies: (use cu101 because colab has CUDA 10.1)
    !pip install cython pyyaml==5.1

    # install detectron2:
    !pip install detectron2==0.1.3 -f https://dl.fbaipublicfiles.com/detectron2/wheels/cu101/torch1.5/index.html

#### usage

1) import dependencies

    # Some basic setup:
    # Setup detectron2 logger
    import detectron2
    from detectron2.utils.logger import setup_logger
    setup_logger()

    # import some common libraries
    import numpy as np
    import cv2
    import random
    from google.colab.patches import cv2_imshow
    import matplotlib.pyplot as plt

    # import some common detectron2 utilities
    from detectron2 import model_zoo
    from detectron2.engine import DefaultPredictor
    from detectron2.config import get_cfg
    from detectron2.utils.visualizer import Visualizer
    from detectron2.data import MetadataCatalog

2) read video

    %%time
    !rm -r frames/*
    !mkdir frames/

    #specify path to video
    video = "sample.mp4"

    #capture video
    cap = cv2.VideoCapture(video)
    cnt=0

    # Check if video file is opened successfully
    if (cap.isOpened()== False): 
    print("Error opening video stream or file")

    ret,first_frame = cap.read()

    #Read until video is completed
    while(cap.isOpened()):
        
    # Capture frame-by-frame
    ret, frame = cap.read()
        
    if ret == True:

        #save each frame to folder        
        cv2.imwrite('frames/'+str(cnt)+'.png', frame)
        cnt=cnt+1
        if(cnt==750):
        break

    # Break the loop
    else: 
        break
    
    #check frame rate of a video
    FPS=cap.get(cv2.CAP_PROP_FPS)
    print(FPS)

 3) download pretrained model

    cfg = get_cfg()

    # add project-specific config (e.g., TensorMask) here if you're not running a model in detectron2's core library
    cfg.merge_from_file(model_zoo.get_config_file("COCO-Detection/faster_rcnn_R_50_C4_3x.yaml"))
    cfg.MODEL.ROI_HEADS.SCORE_THRESH_TEST = 0.9  # set threshold for this model

    # Find a model from detectron2's model zoo. You can use the https://dl.fbaipublicfiles... url as well
    cfg.MODEL.WEIGHTS = model_zoo.get_checkpoint_url("COCO-Detection/faster_rcnn_R_50_C4_3x.yaml")
    predictor = DefaultPredictor(cfg)

4) read and predict image

    #read an image
    img = cv2.imread("frames/30.png")

    #pass to the model
    outputs = predictor(img)

5) visualize detected objects

    # Use `Visualizer` to draw the predictions on the image.
    v = Visualizer(img[:, :, ::-1], MetadataCatalog.get(cfg.DATASETS.TRAIN[0]), scale=1.2)
    v = v.draw_instance_predictions(outputs["instances"].to("cpu"))
    cv2_imshow(v.get_image()[:, :, ::-1])

6) get bounding box of people

    #identity only persons 
    ind = np.where(classes==0)[0]

    #identify bounding box of only persons
    person=bbox[ind]

    #total no. of persons
    num= len(person)

7) compute bottom center of bounding box and distance

    #define a function which return the bottom center of every bbox
    def mid_point(img,person,idx):
        #get the coordinates
        x1,y1,x2,y2 = person[idx]
        _ = cv2.rectangle(img, (x1, y1), (x2, y2), (0,0,255), 2)
        
        #compute bottom center of bbox
        x_mid = int((x1+x2)/2)
        y_mid = int(y2)
        mid   = (x_mid,y_mid)
        
        _ = cv2.circle(img, mid, 5, (0, 0, 255), -1)
        cv2.putText(img, str(idx), mid, cv2.FONT_HERSHEY_SIMPLEX,1, (255, 255, 255), 2, cv2.LINE_AA)
        return mid
    
    %%time
    from scipy.spatial import distance
    def compute_distance(midpoints,num):
    dist = np.zeros((num,num))
    for i in range(num):
        for j in range(i+1,num):
        if i!=j:
            dst = distance.euclidean(midpoints[i], midpoints[j])
            dist[i][j]=dst
    return dist

    %%time
    def find_closest(dist,num,thresh):
        p1=[]
        p2=[]
        d=[]
        for i in range(num):
            for j in range(i,num):
            if( (i!=j) & (dist[i][j]<=thresh)):
                p1.append(i)
                p2.append(j)
                d.append(dist[i][j])
    return p1,p2,d

    def change_2_red(img,person,p1,p2):
    risky = np.unique(p1+p2)
    for i in risky:
        x1,y1,x2,y2 = person[i]
        _ = cv2.rectangle(img, (x1, y1), (x2, y2), (255,0,0), 2)  
    return img

8) repeat for all frames

    import os
    import re

    names=os.listdir('frames/')
    names.sort(key=lambda f: int(re.sub('\D', '', f)))
    def find_closest_people(name,thresh):
        img = cv2.imread('frames/'+name)
        outputs = predictor(img)
        classes=outputs['instances'].pred_classes.cpu().numpy()
        bbox=outputs['instances'].pred_boxes.tensor.cpu().numpy()
        ind = np.where(classes==0)[0]
        person=bbox[ind]
        midpoints = [mid_point(img,person,i) for i in range(len(person))]
        num = len(midpoints)
        dist= compute_distance(midpoints,num)
        p1,p2,d=find_closest(dist,num,thresh)
        img = change_2_red(img,person,p1,p2)
        cv2.imwrite('frames/'+name,img)
        return 0
    
    from tqdm import tqdm
    thresh=100
    _ = [find_closest_people(names[i],thresh) for i in tqdm(range(len(names))) ]

    %%time
    frames = os.listdir('frames/')
    frames.sort(key=lambda f: int(re.sub('\D', '', f)))

    frame_array=[]
    for i in range(len(frames)):
        #reading each files
        img = cv2.imread('frames/'+frames[i])
        img = cv2.cvtColor(img,cv2.COLOR_BGR2RGB)

        height, width, layers = img.shape
        size = (width,height)
        
        #inserting the frames into an image array
        frame_array.append(img)

    out = cv2.VideoWriter('sample_output.mp4',cv2.VideoWriter_fourcc(*'DIVX'), 25, size)
    
    for i in range(len(frame_array)):
        # writing to a image array
        out.write(frame_array[i])
    out.release()