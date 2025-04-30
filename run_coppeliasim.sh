#!/bin/bash

# 确保只使用CoppeliaSim需要的库路径
export LD_LIBRARY_PATH=/Project/coppeliasim:/home/lwb/Project/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04:/usr/local/cuda-11.8/lib64

# 启动CoppeliaSim
cd ~/Project/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04
./coppeliaSim "$@"