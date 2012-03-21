PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# This *still* produces "/Users/will/.rvm/scripts/initialize:50: __rvm_cleanse_variables: function definition file not found"
# errors for me. Boo.
[[ -s "/Users/will/.rvm/scripts/rvm" ]] && source "/Users/will/.rvm/scripts/rvm"