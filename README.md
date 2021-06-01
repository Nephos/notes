# notes

Take notes in your terminal

Compatible crystal v1

## Installation

    make

## Usage

    ./note a note to be written in .local/notes ~~ and a second line to write after the ~~ third line

    Usage: notes [arguments]
        -c=TAG, --category=TAG           Choose a title prefix (change the directory)
        -t=TITLE, --title=TITLE          Change de title (default = HOUR:MINUTE)
        -s=SUBTITLE, --subtitle=TITLE    Change de subtitle (default none)
        -I, --no-increment               Do not increment the last note (new title)
        -P, --show-path                  Show this current file's path
        -p=PATH, --path=PATH             Choose the file's path
        -D, --show-directory             Show this current file's directory
        -d=PATH, --directory=PATH        Choose the file's directory
        -N, --show-name                  Show this current file's name
        -n=NAME, --name=NAME             Choose the file's name
        -w, --week                       Show the last week of notes
        --last-days=N                    Show the last days of notes
        --stdin                          Read on stdin
        -h, --help                       Show this help



## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://git.sceptique.eu/Sceptique/notes/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors


- [Nephos](https://git.sceptique.eu/Sceptique) Arthur Poulet - creator, maintainer
