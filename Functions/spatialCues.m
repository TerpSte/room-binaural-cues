function [ LD ,TD ,CC] = spatialCues( Xright, Xleft )
% Kwdikas apo diplwmatikh Giwrgou Pippou

    len = length(Xright(1, :));
    len2 = length(Xright(:, 1));
    LD=zeros(1, len2);
    TD=zeros(1, len2);
    CC=zeros(1, len2);
    ave=0;
    for i=1:len2
        xri=Xright(i,1:len);
        xle=Xleft(i,1:len);
        LD(i)=10*log10(sum(abs(xri).^2)/sum(abs(xle).^2));
        %Ipologismos TD kai CC
        normCrosCor=normxcorr2(real(xri),real(xle));
        [~, tt]=max(transpose(normCrosCor));
        td=tt-len;
        ave=ave+td;
        meanval=ave/i;
        if td>meanval+10 || td<meanval-10
            TD(i)=round(meanval);
        else
            TD(i)=td;
        end
        CC(i)=max(abs(normCrosCor));
    end
end