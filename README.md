# imgbb.sh
Simple bash script to upload images to imgbb. Supports uploading multiple images at once. Also copied the direct image link to respective clipboard.

## Installation

* Grab an API Key from [https://api.imgbb.com/](https://api.imgbb.com/). Put the API Key into `api_key` (line 11)

* Rename and move the file into PATH, make it executable

#### macOS
Move to /bin 
```bash
mv imgbb.sh /usr/local/bin/imgbb
```
Make it executable 
```bash
chmod +x /usr/local/bin/imgbb
```

#### Linux
Move to ~/bin 
```bash
mv imgbb.sh ~/bin/imgbb
```
Make it executable 
```bash
chmod +x ~/bin/imgbb
```
#### Windows
```bash
Todo. Not tested in Windows. Probably will work via WSL.
```

## Instructions

Single image or image link

```bash
imgbb image.jpg
imgbb https://some.domain/image.jpg
```

Multiple mages or image links

```bash
imgbb image1.jpg image2.jpg image3.jpg
imgbb https://some.domain/image1.jpg https://some.domain/image2.jpg
```

Usage info:

```bash
imgbb -h
imgbb --help
```

