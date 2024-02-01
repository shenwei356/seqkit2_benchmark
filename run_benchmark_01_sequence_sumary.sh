#!/bin/sh

echo Test: Sequence summary

echo -en "\n============================================\n";

echo Plain Text

for f in *.fast{a,q}; do

    echo read file once with cat
    cat $f > /dev/null;


    echo -en "\n------------------------------------\n";

    echo == SeqKit_old
    echo data: $f;

    memusg -t -H seqkit_old stat $f > $f.seqkit_old.txt ;

    /bin/rm $f.seqkit_old.txt;


    echo -en "\n------------------------------------\n";

    echo == SeqKit
    echo data: $f;

    memusg -t -H seqkit stats $f > $f.seqkit.txt ;

    /bin/rm $f.seqkit.txt;


    echo -en "\n------------------------------------\n";

    echo == SeqKit_j1
    echo data: $f;

    memusg -t -H seqkit stats $f -j 1 > $f.seqkit.txt ;

    /bin/rm $f.seqkit.txt;


    echo -en "\n------------------------------------\n";

    echo == Seqtk
    echo data: $f;

    memusg -t -H seqtk size $f > $f.seqtk.txt ;

    /bin/rm $f.seqtk.txt;


    echo -en "\n------------------------------------\n";

    echo == SeqFu
    echo data: $f;

    memusg -t -H seqfu count $f > $f.seqfu.txt ;

    /bin/rm $f.seqfu.txt;
done

echo Gzip files

for f in *.fast{a,q}.gz; do

    echo read file once with cat
    cat $f > /dev/null;


    echo -en "\n------------------------------------\n";

    echo == SeqKit_old
    echo data: $f;

    memusg -t -H seqkit_old stat $f > $f.seqkit_old.txt ;

    /bin/rm $f.seqkit_old.txt;


    echo -en "\n------------------------------------\n";

    echo == SeqKit
    echo data: $f;

    memusg -t -H seqkit stats $f > $f.seqkit.txt ;

    /bin/rm $f.seqkit.txt;


    echo -en "\n------------------------------------\n";

    echo == SeqKit_j1
    echo data: $f;

    memusg -t -H seqkit stats -j 1 $f > $f.seqkit.txt ;

    /bin/rm $f.seqkit.txt;


    echo -en "\n------------------------------------\n";

    echo == Seqtk
    echo data: $f;

    memusg -t -H seqtk size $f > $f.seqtk.txt ;

    /bin/rm $f.seqtk.txt;


    echo -en "\n------------------------------------\n";

    echo == SeqFu
    echo data: $f;

    memusg -t -H seqfu count $f > $f.seqfu.txt ;

    /bin/rm $f.seqfu.txt;

done
