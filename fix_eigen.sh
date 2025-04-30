#!/bin/bash
find . -name "*.h" -o -name "*.hpp" -o -name "*.cpp" | xargs grep -l "Eigen/Eigen" | while read file; do
  echo "修改文件: $file"
  sed -i 's|#include <Eigen/Eigen>|#include <eigen3/Eigen/Dense>\n#include <eigen3/Eigen/Core>|g' "$file"
done
