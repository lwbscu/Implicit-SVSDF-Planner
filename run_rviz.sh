#!/bin/bash

# 保存原始环境变量
OLD_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
OLD_QT_PLUGIN_PATH=$QT_PLUGIN_PATH
OLD_XDG_DATA_DIRS=$XDG_DATA_DIRS

# 移除所有与CoppeliaSim相关的路径
export LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH | sed 's|:/Project/coppeliasim||g' | sed 's|/Project/coppeliasim:||g')

# 确保Qt不会找到CoppeliaSim的插件
export QT_PLUGIN_PATH=$(echo $QT_PLUGIN_PATH | sed 's|:/Project/coppeliasim[^:]*||g' | sed 's|/Project/coppeliasim[^:]*:||g')

# 阻止加载CoppeliaSim的xcb插件
export QT_XCB_GL_INTEGRATION=none

# 显示当前环境(调试用)
echo "使用的LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
echo "使用的QT_PLUGIN_PATH: $QT_PLUGIN_PATH"

# 启动RViz
rosrun rviz rviz "$@"

# 恢复原始环境
export LD_LIBRARY_PATH=$OLD_LD_LIBRARY_PATH
export QT_PLUGIN_PATH=$OLD_QT_PLUGIN_PATH
export XDG_DATA_DIRS=$OLD_XDG_DATA_DIRS