mkdir -p $HOME/.hammerspoon/Spoons
cd  $HOME/.hammerspoon/Spoons
URL=https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip

curl -L -o SpoonInstall.zip $URL 
unzip SpoonInstall.zip
rm SpoonInstall.zip


## zoom spoon https://developer.okta.com/blog/2020/10/22/set-up-a-mute-indicator-light-for-zoom-with-hammerspoon
git clone https://github.com/jpf/Zoom.spoon.git
defaults write "org.hammerspoon.Hammerspoon" "MJShowMenuIconKey" '1'

