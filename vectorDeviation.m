function fp = vectorDeviation(v1,v2)
    fp = (dot(normalize(v1),normalize(v2))+1)/2;
end