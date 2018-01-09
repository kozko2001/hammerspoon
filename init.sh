mkdir -p $HOME/.hammerspoon/Spoons
cd  $HOME/.hammerspoon/Spoons
URL=https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip

curl -L -o SpoonInstall.zip $URL 
unzip SpoonInstall.zip
rm SpoonInstall.zip
