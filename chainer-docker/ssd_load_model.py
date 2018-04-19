#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse

# chainercv
from chainercv.links import SSD300


if __name__ == '__main__':

    p = argparse.ArgumentParser()
    
    p.add_argument("--base-model", help="base model name", default="voc0712")
    p.add_argument("--gpu", "-g", type=int, default=-1)  # use CPU by default

    args = p.parse_args()

    pretrained_model = SSD300(pretrained_model=args.base_model)
