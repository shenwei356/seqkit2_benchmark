#!/bin/sh

echo Test: FASTA/Q reading and writing

echo -en "\n============================================\n";

echo Plain Text

for f in *.fast{a,q}; do

    echo read file once with cat
    cat $f > /dev/null;


    echo -en "\n------------------------------------\n";

    echo == seqkit_old
    echo data: $f;

    memusg -t -H seqkit_old seq $f -w 0 > $f.seqkit_old.fx ;

    /bin/rm $f.seqkit_old.fx;


    echo -en "\n------------------------------------\n";

    echo == seqkit
    echo data: $f;

    memusg -t -H seqkit seq $f -w 0 > $f.seqkit.fx ;

    /bin/rm $f.seqkit.fx;


    echo -en "\n------------------------------------\n";

    echo == seqkit_j1
    echo data: $f;

    memusg -t -H seqkit seq $f -w 0 -j 1 > $f.seqkit.fx ;

    /bin/rm $f.seqkit.fx;


    echo -en "\n------------------------------------\n";

    echo == seqtk
    echo data: $f;

    memusg -t -H seqtk seq $f > $f.seqtk.fx ;

    /bin/rm $f.seqtk.fx;


    echo -en "\n------------------------------------\n";

    echo == seqfu
    echo data: $f;

    memusg -t -H seqfu cat $f > $f.seqfu.fx ;

    /bin/rm $f.seqfu.fx;
done

echo Gzip files

for f in *.fast{a,q}.gz; do

    echo read file once with cat
    cat $f > /dev/null;


    echo -en "\n------------------------------------\n";

    echo == seqkit_old
    echo data: $f;

    memusg -t -H seqkit_old seq $f -w 0 -o $f.seqkit_old.gz;

    /bin/rm $f.seqkit_old.gz;


    echo -en "\n------------------------------------\n";

    echo == seqkit
    echo data: $f;

    memusg -t -H seqkit seq $f -w 0 -o $f.seqkit.gz --compress-level 6 ;

    /bin/rm $f.seqkit.gz;


    echo -en "\n------------------------------------\n";

    echo == seqkit_j1
    echo data: $f;

    memusg -t -H seqkit seq $f -w 0 -j 1 -o $f.seqkit.gz --compress-level 6 ;

    /bin/rm $f.seqkit.gz;


    echo -en "\n------------------------------------\n";

    echo == seqtk+gzip
    echo data: $f;

    memusg -t -H seqtk seq $f | gzip -c > $f.seqtk.gz ;

    /bin/rm $f.seqtk.gz;


    echo -en "\n------------------------------------\n";

    echo == seqtk+pigz
    echo data: $f;

    memusg -t -H seqtk seq $f | pigz -p 4 -c > $f.seqtk.gz ;

    /bin/rm $f.seqtk.gz;


    echo -en "\n------------------------------------\n";

    echo == seqfu+gzip
    echo data: $f;

    memusg -t -H seqfu cat $f | gzip -c > $f.seqfu.gz ;

    /bin/rm $f.seqfu.gz;


    echo -en "\n------------------------------------\n";

    echo == seqfu+pigz
    echo data: $f;

    memusg -t -H seqfu cat $f | pigz -p 4 -c > $f.seqfu.gz ;

    /bin/rm $f.seqfu.gz;
done
