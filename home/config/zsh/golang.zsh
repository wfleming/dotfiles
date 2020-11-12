# Add Go to path
export GOPATH="$HOME/src/golang"
if [[ "$PATH" != *"$GOPATH"* ]]; then
  export PATH="$PATH:$GOPATH/bin"
fi
export GO15VENDOREXPERIMENT=1
