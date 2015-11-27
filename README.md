# video_dect
Final Project of csc420 in University of Toronto

######2015-11-23
division of work
Weidong: face detection, classification, visualization
Rico: Shot detection, logo detection, face tracking

######2015-11-24
**Weidong:**   
         finish face detection
         code is in code/dpm/demo.m
         result is in code/dpm/clip*_det (in n by 4 matrices where each row reprensents a detection)
         visulization of the result is in code/dpm/clip*_det_frame
         
         some parameters used
         clip1: imgdetect -0.3 nms 0.35
         clip2: imgdetect -0.2 nms 0.25
         clip3: imgdetect -0.7 nms 0.22
         
         No face is detected in some frames:
         clip2: 120, 138-143, 176
         clip3: 50-54, 57-62, 64-76, 78-87, 89-90, 93-105, 262-266

         imgdetect will raise an error if no face is detected. (not a big problem).
         
######2015-11-25
**Rico:**  
         shot_detect function take 5 parameters. e.g. shot_detect(65, 199, 'jpg', 'clip_2/', 16) 
         where 16 means there are 16*16 blocks used for getting optical flow, 65 and 199 are the starting and ending image                      numbers. 
         
         shot1, shot2 and shot3 corresponding to clip_1 _2 _3 in shot_data/result are the final shot change image numbers
         
         Questions need to ask Prof: if partial shot change also counts? like 035 in clip_1

######2015-11-25
**Rico:**
         finished face tracking, waiting for face detection result to test 
