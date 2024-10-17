#!/bin/bash
(
echo "During gradle"
cd ../SpringBoot_404/demo
echo "permission"
sudo chmod +x gradlew.bat
echo "build"
sudo ./gradlew build -x test
)
