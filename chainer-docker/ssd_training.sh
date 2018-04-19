#!/bin/bash
dirname=${1:-dataset}

echo "rosrun jsk_perception ssd_train_dataset.py --single-process --gpu 0 ${dirname}/label_names.yaml ${dirname}/"
