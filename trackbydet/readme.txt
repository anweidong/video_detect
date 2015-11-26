###################################
# TRACKING-BY-DETECTION in MATLAB #
#  Andreas Geiger, MPI Tübingen   #
###################################

This is the tracking code that has been used for computing the tracklets
urban scene understanding papers:

@ARTICLE{Geiger2014PAMI,
  author = {Andreas Geiger and Martin Lauer and Christian Wojek and Christoph
	Stiller and Raquel Urtasun},
  title = {3D Traffic Scene Understanding from Movable Platforms},
  journal = {PAMI},
  year = {2014}
}

@INPROCEEDINGS{Zhang2013ICCV,
  author = {Hongyi Zhang and Andreas Geiger and Raquel Urtasun},
  title = {Understanding High-Level Semantics by Modeling Traffic Patterns},
  booktitle = {ICCV},
  year = {2013}
}

Preparation:

If you want to also run the detection part of this toolbox you need to
compile the DPM object detector (otherwise you can also obtain
the pre-computed detections from www.cvlibs.net/software/trackbydet).
To do so, enter the 'lsvm4' directory and run make.m. You also need to
compile the implementation of the Hungarian algorithm by running make.m
in the tracking directory.

Usage:

1) Download the KITTI raw sequences
   - 2011_09_26_drive_0056
   - 2011_09_26_drive_0059
   - 2011_09_29_drive_0026
   from www.cvlibs.net/datasets/kitti/raw_data.php.

2) You need to run the object detector first. You don't need to train it,
   pre-computed models for cars, pedestrians and cyclists can be found
   in the folder 'models'. To run the object detector, first open
   'run_detection.m' and modify the variables base_dir and seq_dir to point
   to one of the downloaded sequences.
   Run the script to compute the object detections. Note that this part
   takes approximately 5-10 seconds per image. The results for the left color
   image (image_02) are stored in the 'object_02' subfolder of the sequence
   directory.

   - OR -

   Alternatively, you can also use the pre-computed detections provided
   within this zip file in the objects folder. Simply put the
   corresponding object_02 folder underneath the corresponding sequence
   folder, ie, 2011_09_26_drive_0056/object_02.

3) To run the tracking stage, open 'run_tracking.m' and modify
   the variables base_dir and seq_dir to point to one of the downloaded
   sequences for which the folder 'object_02' exists. Run the script.
   The tracking results are stored in 'tracking_results.txt'.

4) To visualize the tracking results, , open 'run_visualization.m' and modify
   the variables base_dir and seq_dir to point to one of the downloaded
   sequences for which the file 'tracking_results.txt' exists. Images with
   colored bounding boxes are displayed and stored in the subfolder
   'track_02'.

The script 'run_kitti.m' has been used to create baseline results for the
KITTI tracking benchmark using this algorithm. These results can be accessed
from www.cvlibs.net/datasets/kitti/tracking.php.
