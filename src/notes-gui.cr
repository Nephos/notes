require "qt5"
require "./notes/*"

qApp = Qt::Application.new # Create the application

# Display something on the screen
label = Qt::Label.new "Notes v#{Notes::VERSION}"
label.show

Qt::Application.exec # And run it!
