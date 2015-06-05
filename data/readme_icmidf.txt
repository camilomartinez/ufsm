icm_idf has been created by multiplying each row (i.e., each metadata) by the logarithm of the inverse of the frequency of such metadata in the catalog (with respect to the number of items), as follows:

stemOcc = log10(size(icm,2) ./ full(sum(icm,2)));
icm_idf = normalizeMatrixWithVector(icm,stemOcc,1);