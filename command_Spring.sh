#!/bin/bash
(
echo "During gradle"
cd ./SpringBoot_404/demo
echo "permission"
chmod +x gradlew.bat
echo "build"
./gradlew build -x test
)
