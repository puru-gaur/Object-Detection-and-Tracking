function [lemon_on_spoon,xto] = lemon_sam_2(vid_path)
obj = VideoReader(vid_path);
vid = read(obj);
xto=[];
lmaxo=0;
bs=0;
for x = 1:size(vid,4)
      Vid=double(vid(:,:,:,x));
      bs=bs+Vid;
 end
 bs=bs/size(vid,4);
 for i=1:size(vid,4)
    I=double(vid(:,:,:,i));
    fg=mean(abs(I-bs),3);
     fgo=mat2gray(fg);
    fgox=fgo;
    yellow=mat2gray(I(:,:,1)/2+I(:,:,2)/2-I(:,:,3),[0 255]);
    fgo((yellow>=0.7*max(yellow(:))) & (fgo>0.7*max(fgo(:))))=1;
   fgo(yellow<0.7*max(yellow(:)))=0;
   tt=max(yellow(:));
   if tt>lmaxo
       lmaxo=tt;
   end

    if tt<0.7*max(0.1,lmaxo);
         fgo(:)=0;
    else
        CC=bwconncomp(logical(fgo));
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [~,idx] = max(numPixels);
        S = regionprops(CC,'Centroid');
        xt=S(idx).Centroid;
        xto=[xto;xt];
    end
 end
    sm=mean(xto);
sml=mean(xto(round(0.9*size(xto,1)):end,:));
lemon_on_spoon=1;
if sml(2)-sm(2)>50    
    lemon_on_spoon=0;
    disp('FALSE: Lemon has fallen')
else
    disp('TRUE: Lemon has not fallen')
end
figure,plot(1:size(xto,1),xto(:,2));
axis([1 size(xto,1) 1 size(I,1)]);
end
