---
layout:     post
title:      tensorflow RCNN
subtitle:   
date:       2020-09-13
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

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