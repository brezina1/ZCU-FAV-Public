function cloneFig(hf1,hf2)
compCopy(hf1,hf2);

function compCopy(op, np)
	ch = get(op, 'children');
	if ~isempty(ch)
	    nh = copyobj(ch,np);
	    for k = 1:length(ch)
% 		    compCopy(ch(k),nh(k));
            bh(k) = ch(k);
	    end
    end
end
end