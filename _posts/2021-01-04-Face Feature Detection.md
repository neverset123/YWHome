---
layout:     post
title:      face feature detection
subtitle:   
date:       2021-01-04
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - machine learning
---


## DLib
a machine learning library for image processing using the C++ providing C/C++, Python, and Java interface. Dlib is able to detect face features and provide a map of landmark points that surround each feature

### installation and usage

        #pipenv install opencv-python, dlib
        #following is an example for video real time face feature detection
        import cv2
        import dlib

        # Load the detector
        detector = dlib.get_frontal_face_detector()
        # Load the predictor
        predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")
        # read the image
        cap = cv2.VideoCapture(0)
        while True:
        _, frame = cap.read()
        # Convert image into grayscale
        gray = cv2.cvtColor(src=frame, code=cv2.COLOR_BGR2GRAY)
        # Use detector to find landmarks
        faces = detector(gray)
        for face in faces:
                x1 = face.left()  # left point
                y1 = face.top()  # top point
                x2 = face.right()  # right point
                y2 = face.bottom()  # bottom point
                # Create landmark object
                landmarks = predictor(image=gray, box=face)
                # Loop through all the points
                for n in range(0, 68):
                x = landmarks.part(n).x
                y = landmarks.part(n).y
                # Draw a circle
                cv2.circle(img=frame, center=(x, y), radius=3, color=(0, 255, 0), thickness=-1)

        # show the image
        cv2.imshow(winname="Face", mat=frame)
        # Exit when escape is pressed
        if cv2.waitKey(delay=1) == 27:
                break
        # When everything done, release the video capture and video write objects
        cap.release()
        # Close all windows
        cv2.destroyAllWindows()