#!/bin/bash

# 保存原始的LD_LIBRARY_PATH
OLD_LD_LIBRARY_PATH=$LD_LIBRARY_PATH

# 移除CoppeliaSim的路径
export LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH | sed 's|:/Project/coppeliasim||g')

# 显示当前的路径(调试用)
echo "使用的LD_LIBRARY_PATH: $LD_LIBRARY_PATH"

# 启动规划器(根据需要修改launch文件名)
roslaunch plan_manager "$@"

# 恢复原始的LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$OLD_LD_LIBRARY_PATH