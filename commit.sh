#!/bin/bash

DATE=`date`
# TEXT=`curl https://v1.hitokoto.cn | python -c "import sys, json; print json.load(sys.stdin)['hitokoto']"
TEXT="hello world"

# cd /data/www/resume/

echo $TEXT >> text.log

git add --all

git commit -m "$TEXT"

git pull origin hexo

git push origin hexo

# curl https://sc.ftqq.com/SCU10625Td571049c53dd2e36148f1343a18544ef59855df9df77c.send?text="$TEXT"



# chmod +x ./test.sh  #使脚本具有执行权限
# ./test.sh  #执行脚本

# git add .

# git commit -m"update"

# git pull origin hexo

# git push origin hexo
