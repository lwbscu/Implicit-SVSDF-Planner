#!/bin/bash

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 无颜色

echo -e "${BLUE}===== CMake 版本声明批量替换工具 =====${NC}"
echo -e "${YELLOW}查找所有需要修改的文件...${NC}"

# 使用 grep 查找所有包含目标模式的文件 (不区分大小写 -i)
FILES=$(grep -l -i -E "cmake_minimum_required\(VERSION|CMAKE_MINIMUM_REQUIRED\(VERSION|set\(REQUIRED_CMAKE_VERSION" -r .)

if [ -z "$FILES" ]; then
    echo -e "${RED}未找到任何包含目标模式的文件。${NC}"
    exit 1
fi

# 统计找到的文件数量
FILE_COUNT=$(echo "$FILES" | wc -l)
echo -e "${GREEN}找到 $FILE_COUNT 个文件将被修改:${NC}"
echo "$FILES"

# 询问用户是否继续
read -p "确认要修改这些文件吗? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "操作已取消。"
    exit 0
fi

echo -e "${YELLOW}执行替换操作...${NC}"

# 初始化计数器
total_files_modified=0
cmake_min_count=0
cmake_min_upper_count=0
required_version_count=0

# 对每个文件执行替换
for file in $FILES; do
    # 跳过二进制文件和特殊文件
    if file "$file" | grep -q "binary"; then
        echo -e "${RED}跳过二进制文件: $file${NC}"
        continue
    fi
    
    modified=0
    
    # 1. 替换小写形式 cmake_minimum_required
    if grep -q "cmake_minimum_required(VERSION" "$file"; then
        sed -i 's/cmake_minimum_required(VERSION [0-9.]\+)/cmake_minimum_required(VERSION 3.5)/' "$file"
        
        # 确认替换是否成功
        if grep -q "cmake_minimum_required(VERSION 3.5)" "$file"; then
            echo -e "${GREEN}✓ 修改 cmake_minimum_required: $file${NC}"
            cmake_min_count=$((cmake_min_count+1))
            modified=1
        fi
    fi
    
    # 2. 替换大写形式 CMAKE_MINIMUM_REQUIRED
    if grep -q -i "CMAKE_MINIMUM_REQUIRED(VERSION" "$file" && ! grep -q "cmake_minimum_required(VERSION" "$file"; then
        sed -i 's/CMAKE_MINIMUM_REQUIRED(VERSION [0-9.]\+)/CMAKE_MINIMUM_REQUIRED(VERSION 3.5)/I' "$file"
        
        # 确认替换是否成功
        if grep -q -i "CMAKE_MINIMUM_REQUIRED(VERSION 3.5)" "$file"; then
            echo -e "${GREEN}✓ 修改 CMAKE_MINIMUM_REQUIRED: $file${NC}"
            cmake_min_upper_count=$((cmake_min_upper_count+1))
            modified=1
        fi
    fi
    
    # 3. 替换 REQUIRED_CMAKE_VERSION
    if grep -q "set(REQUIRED_CMAKE_VERSION" "$file"; then
        sed -i 's/set(REQUIRED_CMAKE_VERSION "[^"]*")/set(REQUIRED_CMAKE_VERSION "3.5")/' "$file"
        
        # 确认替换是否成功
        if grep -q 'set(REQUIRED_CMAKE_VERSION "3.5")' "$file"; then
            echo -e "${GREEN}✓ 修改 REQUIRED_CMAKE_VERSION: $file${NC}"
            required_version_count=$((required_version_count+1))
            modified=1
        fi
    fi
    
    # 统计修改的文件数
    if [ "$modified" -eq 1 ]; then
        total_files_modified=$((total_files_modified+1))
    fi
done

# 打印统计信息
echo -e "\n${BLUE}===== 执行完成 =====${NC}"
echo -e "${GREEN}总计修改了 ${total_files_modified} 个文件${NC}"
echo -e "- cmake_minimum_required 被修改的次数: ${cmake_min_count}"
echo -e "- CMAKE_MINIMUM_REQUIRED 被修改的次数: ${cmake_min_upper_count}"
echo -e "- REQUIRED_CMAKE_VERSION 被修改的次数: ${required_version_count}"