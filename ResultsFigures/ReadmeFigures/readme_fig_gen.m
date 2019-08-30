peak_magnitudes = [1.3,2]
radii = 3;
smoothing = [10,20];
image_dimensions = [100,150];
peak_locations =  {[40,30], [70,120]}

Sig = gensig(peak_magnitudes, radii, smoothing, image_dimensions, peak_locations);
surf(Sig)

export_fig([rftboxloc, 'Figures/readme_1Dreal.png'], '-transparent')


