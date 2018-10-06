# pastebin
###### send text files to pastebin

<a href="https://asciinema.org/a/BHRFvPUWv7rJKiysAZmMlrE2v?autoplay=1&t=00:10">
  <img src="https://asciinema.org/a/BHRFvPUWv7rJKiysAZmMlrE2v.png" width="320px" height="200px" alt="" />
</a>

### Installation
```bash
git clone https://github.com/Manu-sh/pastebin
gem install nokogiri

cp -r pastebin /opt

# edit you .bashrc and add /opt/pastebin/bin to your $PATH
PATH="${PATH}:/opt/pastebin/bin"

# then you should be able to type
pastebin -h
```

### Troubleshooting
If somethings doesn't work as expected try to remove `/tmp/pastebin_opt.rb` this file contain a list of available opt and it's automatically generated by parsing the html DOM of pastebin.com

```bash
rm /tmp/pastebin_opt.rb
```

###### Copyright © 2018, [Manu-sh](https://github.com/Manu-sh), s3gmentationfault@gmail.com. Released under the [GPL3 license](LICENSE).
