function [y1, fs] = audio_spiral(mag, ang, cen_rad, time_shift, file)


angle = 0:0.01:ang*pi;
% mag = 40;
% cen_rad = 1;
% time_shift = 35000;

len = length(angle);
radius = zeros(1, len);



[y1,fs] = audioread(file);
y1 = y1(1+time_shift:len+time_shift);
Ts = 1/fs;
t = 0:Ts:(length(y1)*Ts)-Ts;
rad_plot = rot90(abs(y1))*mag;
soundsc(y1,fs)

%plot(t,rad_plot)
a = 1;
for i = 1:length(radius)
    if (angle(i) < cen_rad) 
        radius(i) = angle(a) + rad_plot(a);
        
    else
        a = i;
        radius(i) = angle(i) + rad_plot(i);
    end
end
figure
plot(radius.*cos(angle), radius.*sin(angle))
axis off

end

