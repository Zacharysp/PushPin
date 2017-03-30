# PushPin Spec

## Resolution (number of pushpins)

example with photo was taken from iphone default camera

1. low quality 50 * 67 = 3350

2. median quality 75 * 100 = 7500

3. high quality 100 * 134 = 13400

## Color Picker

1. user provided color array, 4 to 10 color

2. calculated color array, 4 to 10 color

## Image modification

1. reduce image quality to selected resolution.

2. increase image saturation

3. increase color contrast

4. reduce color number 

5. get dominant color or have user provided color

6. find nearest color for each pixel(pushpin)

7. draw new image with circle pixel.


## workflow

1. start new.

2. choose resolution.

3. choose from library or take a new photo.

4. add filter.

5. crop.

6. resize.

7. dominant color and adjust saturation, contrast.

8. choose color.

9. generate pushpin image.

