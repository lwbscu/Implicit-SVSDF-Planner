#!/bin/bash

# 保存脚本到~/ros_tools/env_reset.sh
cat > ~/ros_tools/env_reset.sh << 'EOF'
#!/bin/bash

# 保存所有可能需要恢复的变量
_OLD_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
_OLD_QT_PLUGIN_PATH=$QT_PLUGIN_PATH
_OLD_XDG_DATA_DIRS=$XDG_DATA_DIRS
_OLD_QT_QPA_PLATFORM_PLUGIN_PATH=$QT_QPA_PLATFORM_PLUGIN_PATH

# 清除所有可能包含CoppeliaSim路径的变量
export LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH | sed 's|/Project/coppeliasim[^:]*:||g' | sed 's|:/Project/coppeliasim[^:]*||g')
unset QT_PLUGIN_PATH
unset QT_QPA_PLATFORM_PLUGIN_PATH

# 设置Qt环境变量以使用系统库
export QT_XCB_GL_INTEGRATION=none

# 为ROS设置必要的路径
if [ ! -z "$LD_LIBRARY_PATH" ]; then
  export LD_LIBRARY_PATH=/opt/ros/noetic/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
else
  export LD_LIBRARY_PATH=/opt/ros/noetic/lib:/usr/lib/x86_64-linux-gnu
fi

# 函数：恢复原始环境
restore_env() {
  export LD_LIBRARY_PATH=$_OLD_LD_LIBRARY_PATH
  export QT_PLUGIN_PATH=$_OLD_QT_PLUGIN_PATH
  export XDG_DATA_DIRS=$_OLD_XDG_DATA_DIRS
  export QT_QPA_PLATFORM_PLUGIN_PATH=$_OLD_QT_QPA_PLATFORM_PLUGIN_PATH
  unset _OLD_LD_LIBRARY_PATH _OLD_QT_PLUGIN_PATH _OLD_XDG_DATA_DIRS _OLD_QT_QPA_PLATFORM_PLUGIN_PATH
}

# 捕获CTRL+C和退出信号以恢复环境
trap restore_env EXIT INT TERM

# 运行传入的命令
"$@"
EOF

chmod +x ~/ros_tools/env_reset.sh